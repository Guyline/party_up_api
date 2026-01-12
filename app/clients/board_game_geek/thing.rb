##
# Represents a playable entity (e.g. a game or expansion)
#
module BoardGameGeek
  class Thing
    attr_reader :expansions,
      :id,
      :image_url,
      :name,
      :thumbnail_url,
      :versions

    def initialize(id: nil, name: nil, thumbnail_url: nil, image_url: nil)
      raise "ID must be specified." unless id.is_a?(Integer) && id.positive?

      @expansions = {}
      @id = id
      @image_url = image_url
      @name = name
      @thumbnail_url = thumbnail_url
      @versions = {}
    end

    def add_version(version)
      raise "Specified record is not a version." unless version.is_a?(BoardGameGeek::Version)

      @versions[version.id] = version

      @versions
    end

    def add_expansion(expansion, add_as_expandable: true)
      raise "Specified record is not an expansion." unless expansion.is_a?(BoardGameGeek::Expansion)

      @expansions[expansion.id] = expansion
      expansion.add_expandable(self, add_as_expansion: false) if add_as_expandable

      @expansions
    end

    class << self
      def find(id, cached_only: false)
        if cached_only
          Rails.cache.read(cache_key(id))
        else
          Rails.cache.fetch(cache_key(id), expires_in: cache_ttl) do
            BoardGameGeek::Query.find(id)
          end
        end
      end

      def for_user(user)
        unless user.instance_of?(User) && !user.bgg_username&.empty?
          raise "Unable to fetch BGG collection for specified user."
        end

        url = "collection"
        params = {
          username: user.bgg_username,
          own: 1,
          version: 1
        }

        BoardGameGeek::Query.new(url:, params:)
      end

      def with_ids(ids)
        url = "thing"
        params = {
          id: ids.is_a?(Array) ? ids.join(",") : ids
        }

        BoardGameGeek::Query.new(url:, params:)
      end

      protected

      def cache_key(id)
        "bgg-playable/#{id}"
      end

      def cache_ttl
        15.minutes
      end
    end

    protected

    def cache_key
      self.class.cache_key(@id)
    end
  end
end
