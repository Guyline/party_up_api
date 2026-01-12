class Item < ApplicationRecord
  include HasPublicId

  self.public_id_prefix = "itm"

  delegated_type :playable,
    types: %w[
      Game
      Expansion
    ],
    dependent: :destroy,
    optional: true

  validates :name,
    presence: true
  validates :bgg_id,
    uniqueness: true,
    allow_nil: true

  has_many :item_expansions,
    class_name: "ItemExpansion",
    inverse_of: :item
  has_many :expansions,
    through: :item_expansions,
    source: :expansion

  has_many :copies,
    inverse_of: :item
  has_many :holders,
    -> { distinct },
    through: :copies,
    source: :holder

  has_many :ownerships,
    through: :copies,
    source: :ownerships
  has_many :owners,
    -> { distinct },
    through: :ownerships,
    source: :owner

  has_many :versions,
    inverse_of: :item

  default_scope do
    includes(:playable)
  end

  def resynchronize
    raise "Unable to resychronize record without :bgg_id specified" unless bgg_id

    ResynchronizeItemsJob.perform_async(id)
  end

  def classification
    playable_type&.demodulize&.underscore
  end

  class << self
    def from_bgg_thing(thing, with_expansions: false, with_expandables: false)
      raise ArgumentError, "Expected instance of BoardGameGeek::Thing" unless thing.is_a?(BoardGameGeek::Thing)

      item = find_or_initialize_by(bgg_id: thing.id)
      item.bgg_image_url = thing.image_url || item.bgg_image_url
      item.bgg_thumbnail_url = thing.thumbnail_url || item.bgg_thumbnail_url
      item.name = thing.name || item.name

      if thing.is_a?(BoardGameGeek::Game)
        item.playable = Game.create!
      elsif thing.is_a?(BoardGameGeek::Expansion)
        item.playable = Expansion.create!
      end

      item.save!

      if with_expansions
        thing.expansions.each_value do |bgg_expansion|
          expansion_item = from_bgg_thing(bgg_expansion)
          unless expansion_item.playable.is_a?(Expansion)
            raise "Non-expansion item found/created when processing BGG thing."
          end

          item.item_expansions.find_or_create_by!(expansion: expansion_item.playable)
        end
      end

      if with_expandables && thing.respond_to?(:expandables) && item.playable.is_a?(Expansion)
        thing.expandables.each_value do |bgg_expandable|
          expandable_item = from_bgg_thing(bgg_expandable)
          raise "Non-expandable item found/created when processing BGG thing." unless expandable_item.is_a?(Item)

          item.playable.item_expansions.find_or_create_by!(item: expandable_item)
        end
      end

      item
    end

    def resynchronize(untyped_only: true)
      query_base = where.not(bgg_id: nil)
      query_base.where.missing(:playable) if untyped_only

      processed_ids = []
      batch_size = 20
      loop do
        ids = query_base.where.not(id: processed_ids)
          .limit(batch_size)
          .pluck(:id)
        break if ids.empty?

        ResynchronizeItemsJob.perform_async(ids)

        processed_ids += ids
      end
    end
  end
end
