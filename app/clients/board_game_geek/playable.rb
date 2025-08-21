# Represents a playable entity (e.g. a game or expansion)
class BoardGameGeek::Playable
  class_attribute :object_ids,
    default: {},
    instance_predicate: false,
    instance_accessor: false

  attr_reader :expansions,
    :id,
    :image_url,
    :name,
    :thumbnail_url,
    :versions

  def initialize(id: nil, name: nil, thumbnail_url: nil, image_url: nil)
    @expansions = {}
    @id = id
    @image_url = image_url
    @name = name
    @thumbnail_url = thumbnail_url
    @versions = []

    Playable.register(self)
  end

  def find_or_create_playable
    ::Playable.find_or_create_by!(bgg_id: @id) do |playable|
      playable.name = @name
      playable.bgg_image_url = @image_url
      playable.bgg_thumbnail_url = @thumbnail_url
    end
  end

  def add_version(version)
    @versions[] = version
  end

  def add_expansion(expansion, add_as_expandable: true)
    raise "Specified record is not an expansion." unless expansion.is_a?(BoardGameGeek::Expansion)

    @expansions[expansion.id] = expansion
    return unless add_as_expandable && !expansion.expandables.key(@id)

    expansion.add_expandable(self, add_as_expansion: false)
  end

  class << self
    def register(playable)
      object_ids[playable.id] = playable.object_id
      ObjectSpace.define_finalizer(playable, method(:finalize))
    end

    def finalize(id)
      object_ids.delete(id)
    end

    def find(id, fresh: true)
      object_id = object_ids[id]
      if object_id
        begin
          playable = ObjectSpace._id2ref(object_id)
          return playable if playable
        rescue RangeError
          # Object was garbage collected, continue with fresh fetch
        end
      end

      fresh ? Query.find(id) : nil
    end

    def for_user(user)
      unless user.instance_of?(::User) && !user.bgg_username.empty?
        raise "Unable to fetch BGG collection for specified user."
      end

      username = user.bgg_username

      url = "collection"
      params = {username:, own: 1, version: 1}

      Query.new(url:, params:)
    end

    def with_ids(ids)
      url = "thing"
      params = {id: ids.is_a?(Array) ? ids.join(",") : ids}

      Query.new(url:, params:)
    end
  end
end
