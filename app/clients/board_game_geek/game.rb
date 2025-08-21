class BoardGameGeek::Game < Playable
  class_attribute :object_ids,
    default: {},
    instance_predicate: false,
    instance_accessor: false

  def initialize(id: nil, name: nil, thumbnail_url: nil, image_url: nil)
    super

    Game.register(self)
  end

  def find_or_create_game(find_or_create_expansions: false)
    game = ::Playable.find_or_create_by!(bgg_id: @id) do |g|
      g.name = @name
      g.bgg_image_url = @image_url
      g.bgg_thumbnail_url = @thumbnail_url
    end

    raise "Playable already listed as an expansion." if game.is_a?(::Expansion)

    unless game.type
      game.becomes!(::Game)
      game.save!
    end

    game = ::Game.find(game.id)

    if find_or_create_expansions
      @expansions.each_value do |bgg_expansion|
        expansion = bgg_expansion.find_or_create_expansion
        next unless expansion

        game.playable_expansions.find_or_create_by!(expansion:)
      end
    end

    game
  end
end
