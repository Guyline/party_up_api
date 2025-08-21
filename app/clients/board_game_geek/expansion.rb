class BoardGameGeek::Expansion < Playable
  class_attribute :object_ids,
    default: {},
    instance_predicate: false,
    instance_accessor: false

  attr_reader :expandables

  def initialize(id: nil, name: nil, thumbnail_url: nil, image_url: nil)
    super

    @expandables = {}
    Expansion.register(self)
  end

  def add_expandable(expandable, add_as_expansion: true)
    @expandables[expandable.id] = expandable
    return unless add_as_expansion && !expandable.expansions.key?(@id)

    expandable.add_expansion(self, add_as_expandable: false)
  end

  def find_or_create_expansion(find_or_create_expandables: false, find_or_create_expansions: false)
    expansion = ::Playable.find_or_create_by!(bgg_id: @id) do |e|
      e.name = @name
      e.bgg_image_url = @image_url
      e.bgg_thumbnail_url = @thumbnail_url
    end

    raise "Playable already listed as a game." if expansion.is_a?(::Game)

    unless expansion.type
      expansion.becomes!(::Expansion)
      expansion.save!
    end

    expansion = ::Expansion.find(expansion.id)

    if find_or_create_expandables
      @expandables.each_value do |bgg_expandable|
        expandable = if bgg_expandable.is_a?(BoardGameGeek::Game)
          bgg_expandable.find_or_create_game
        elsif bgg_expandable.is_a?(BoardGameGeek::Expansion)
          bgg_expandable.find_or_create_expansion
        end
        next unless expandable

        expansion.playable_expansions_as_expansion.find_or_create_by!(playable: expandable)
      end
    end

    if find_or_create_expansions
      @expansions.each_value do |bgg_expansion|
        expanding_expansion = bgg_expansion.find_or_create_expansion
        next unless expanding_expansion

        expansion.playable_expansions_as_playable.find_or_create_by!(expansion: expanding_expansion)
      end
    end

    expansion
  end

  def self.add_instance(instance)
    super
    superclass.add_instance(instance)
  end
end
