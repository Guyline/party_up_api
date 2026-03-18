class Item < ApplicationRecord
  include HasPublicId

  self.public_id_prefix = "itm"

  validates :name,
    presence: true
  validates :bgg_id,
    uniqueness: true,
    allow_nil: true

  has_many :item_expansions_as_expandable,
    class_name: "ItemExpansion",
    inverse_of: :expandable_item
  has_many :expansions,
    through: :item_expansions_as_expandable,
    source: :expansion_item

  has_many :item_expansions_as_expansion,
    class_name: "ItemExpansion",
    inverse_of: :expansion_item
  has_many :expandables,
    through: :item_expansions_as_expansion,
    source: :expandable_item

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

  def resynchronize
    raise "Unable to resychronize record without :bgg_id specified" unless bgg_id

    ResynchronizeItemsJob.perform_async(id)
  end

  def category
    type&.demodulize&.underscore
  end

  class << self
    def from_bgg_thing(thing, with_expansions: false, with_expandables: false)
      pp thing.class
      raise ArgumentError, "Expected instance of BoardGameGeek::Thing" unless thing.is_a?(BoardGameGeek::Thing)

      item = find_or_initialize_by(bgg_id: thing.id)
      item.bgg_image_url = thing.image_url || item.bgg_image_url
      item.bgg_thumbnail_url = thing.thumbnail_url || item.bgg_thumbnail_url
      item.name = thing.name || item.name

      item = case thing
      when BoardGameGeek::Game
        item.becomes! Game
      when BoardGameGeek::Expansion
        item.becomes! Expansion
      else
        item
      end
      pp item

      item.save!

      if with_expansions
        thing.expansions.each_value do |bgg_expansion|
          expansion_item = from_bgg_thing(bgg_expansion)
          unless expansion_item.is_a?(Expansion)
            raise "Non-expansion item found/created when processing BGG thing."
          end

          item.expansions << expansion_item
        end
      end

      if with_expandables && thing.respond_to?(:expandables) && item.respond_to?(:expandable_items)
        thing.expandables.each_value do |bgg_expandable|
          expandable_item = from_bgg_thing(bgg_expandable)
          unless expandable_item.is_a?(Item)
            raise "Non-expandable item found/created when processing BGG thing."
          end

          item.expandable_items << expandable_item
        end
      end

      item
    end

    def resynchronize(untyped_only: true)
      query_base = where.not(bgg_id: nil)
      query_base.where(type: nil) if untyped_only

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
