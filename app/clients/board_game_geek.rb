require 'json'

module BoardGameGeek
  BASE_URL = 'https://boardgamegeek.com/xmlapi2'.freeze

  class Version
    attr_reader :id, :name, :publication_year

    def initialize(id, name, publication_year: nil)
      @id = id
      @name = name
      @publication_year = publication_year
    end
  end

  class Playable
    attr_reader :expansions,
                :id,
                :image_url,
                :name,
                :thumbnail_url,
                :type,
                :versions

    def initialize(id, name, thumbnail_url: nil, image_url: nil)
      @expansions = {}
      @id = id
      @image_url = image_url
      @name = name
      @thumbnail_url = thumbnail_url
      @versions = []
    end

    def add_version(version)
      @versions[] = version
    end

    def add_expansion(expansion, add_as_expandable: true)
      raise 'Specified record is not an expansion.' unless expansion.is_a?(BoardGameGeek::Expansion)

      @expansions[expansion.id] = expansion
      return unless add_as_expandable && !expansion.expandables.key(@id)

      expansion.add_expandable(self, add_as_expansion: false)
    end

    def self.find(ids)
      url = "#{BASE_URL}/thing"
      params = { id: ids.is_a?(Array) ? ids.join(',') : ids }

      response = execute_request(:get, url, params)
      raise 'UNABLE TO GET SUCCESSFUL RESPONSE.' unless response&.code == 200

      bgg_playables = Hash.from_xml(response.body).dig('items', 'item')
      bgg_playables = [bgg_playables] unless bgg_playables.is_a?(Array)
      raise 'UNABLE TO PARSE BGG RESPONSE.' unless bgg_playables

      playables = {}
      bgg_playables.each do |bgg_playable|
        id = bgg_playable['id']&.to_i
        bgg_names = bgg_playable['name']
        bgg_name = if bgg_names.is_a?(Array)
                     bgg_names.find { |n| n['type'] == 'primary' }
                   else
                     bgg_names
                   end
        name = bgg_name&.dig('value')

        playable = case bgg_playable['type']
                   when 'boardgame'
                     BoardGameGeek::Game.new id, name
                   when 'boardgameexpansion'
                     BoardGameGeek::Expansion.new id, name
                   else
                     p "Unknown playable type detected #{bgg_playable['type']}."
                     next
                   end

        bgg_links = bgg_playable['link']
        bgg_links = [bgg_links] unless bgg_links.is_a?(Array)
        bgg_links.select { |link| link['type'] == 'boardgameexpansion' }.each do |bgg_link|
          link_id = bgg_link['id']&.to_i
          link_name = bgg_link['value']
          next if playables.key?(link_id)

          case playable
          when BoardGameGeek::Game
            expansion = playables[link_id] || BoardGameGeek::Expansion.new(link_id, link_name)
            playable.add_expansion(expansion)
            playables[link_id] = expansion
          when BoardGameGeek::Expansion
            # expandable = playables[link_id]
            # # TODO: FIGURE OUT HOW TO HANDLE EXPANSION CHAINS BETTER
            # expandable ||= if bgg_link['inbound'] == 'true'
            #                  BoardGameGeek::Game.new(link_id, link_name)
            #                else
            #                  BoardGameGeek::Expansion.new(link_id, link_name)
            #                end
            # playable.add_expandable(expandable)
            # playables[link_id] = expandable
          else
            p playable.class
          end
        end
        playables[id] = playable
      end
      playables
    end

    def self.for_user(user, seed: false, attempts_count: 100, delay_seconds: 5)
      unless user.instance_of?(::User) && !user.bgg_username.empty?
        raise 'Unable to fetch BGG collection for specified user.'
      end

      username = user.bgg_username

      url = "#{BASE_URL}/collection"
      params = { username:, own: 1, version: 1 }

      response = execute_request(:get, url, params, attempts_count:, delay_seconds:)
      raise 'UNABLE TO GET SUCCESSFUL RESPONSE FROM BGG API.' unless response&.code == 200

      items = Hash.from_xml(response.body)

      print 'Processing playables'
      bgg_playables = items.dig('items', 'item')
      bgg_playables.map do |bgg_playable|
        print '.'
        bgg_id = bgg_playable['objectid']&.to_i
        next unless bgg_id

        name = bgg_playable['name']
        image_url = bgg_playable['image']
        thumbnail_url = bgg_playable['thumbnail']

        playable = if seed
                     ::Playable.find_or_create_by!(bgg_id:) do |g|
                       g.name = name
                       g.bgg_image_url = image_url
                       g.bgg_thumbnail_url = thumbnail_url
                     end
                   else
                     new(bgg_id, name, image_url:, thumbnail_url:)
                   end

        bgg_versions = bgg_playable.dig('version', 'item')
        if (!bgg_versions || bgg_versions.empty?) && seed
          copy = ::Copy.find_or_create_by!(holder: user, playable:) do |c|
            # pp c
          end
          copy.ownerships.find_or_create_by!(owner: user) do |o|
            # pp o
          end
          next
        end

        bgg_versions = [bgg_versions] unless bgg_versions.instance_of?(Array)
        bgg_versions.each do |bgg_version|
          bgg_id = bgg_version['id']&.to_i
          unless bgg_id
            print "Unable to derive ID from playable version, skipping...\n"
            next
          end

          names = bgg_version['name']
          names = [names] unless names.instance_of?(Array)
          name = names.find { |n| n['type'] == 'primary' }['value']
          publication_year = bgg_version.dig('yearpublished', 'value')&.to_i

          if seed
            version = ::Version.find_or_create_by!(bgg_id:) do |v|
              v.playable = playable
              v.name = name
              v.publication_year = publication_year
              # pp v
            end
            copy = ::Copy.find_or_create_by!(holder: user, playable:, version: nil) do |c|
              c.version = version
              # pp c
            end
            copy.ownerships.find_or_create_by!(owner: user) do |o|
              # pp o
            end
          else
            version = Version.new(bgg_id, name, publication_year:)
            playable.add_version(version)
          end
        end
      end
    end

    def self.execute_request(method, url, params, attempts_count: 100, delay_seconds: 5)
      http_statuses = Rack::Utils::SYMBOL_TO_STATUS_CODE
      attempts_count.times do |i|
        base_message = "Attempt ##{i + 1}: "
        begin
          response = RestClient::Request.execute(method:, url:, headers: { params: })
        rescue RestClient::ExceptionWithResponse => e
          p "#{base_message}Exception encountered! - HTTP #{e.http_code}"
          pp e.http_body
          sleep(delay_seconds)
          next
        end

        case response.code
        when http_statuses[:accepted]
          print "#{base_message}Request accepted, processing...\n"
          sleep(delay_seconds)
          next
        when http_statuses[:ok]
          print "#{base_message}Request complete!\n"
          return response
        else
          print "#{base_message}HTTP #{response.code} encountered, continuing...\n"
          sleep(delay_seconds)
          next
        end
      end

      nil
    end
  end

  class Game < Playable
    def find_or_create_game(find_or_create_expansions: false)
      game = ::Playable.find_or_create_by!(bgg_id: @id) do |g|
        g.name = @name
        g.bgg_image_url = @image_url
        g.bgg_thumbnail_url = @thumbnail_url
        g.becomes!(::Playable::Game)
      end

      raise 'Playable already listed as an expansion.' if game.type == ::Playable::Expansion.class

      unless game.type
        game.becomes!(::Playable::Game)
        game.save!
      end

      game = ::Playable::Game.find(game.id)

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

  class Expansion < Playable
    attr_reader :expandables

    def initialize(id, name, thumbnail_url: nil, image_url: nil)
      super(id, name, thumbnail_url:, image_url:)
      @expandables = {}
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
        e.becomes!(::Playable::Expansion)
      end

      raise 'Playable already listed as a game.' if expansion.type == ::Playable::Game.class

      unless expansion.type
        expansion.becomes!(::Playable::Expansion)
        expansion.save!
      end

      expansion = ::Playable::Expansion.find(expansion.id)

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
  end
end
