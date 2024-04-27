require 'json'

module BoardGameGeek
  BASE_URL = 'https://boardgamegeek.com/xmlapi2'.freeze

  class Version
    def initialize(id, name, publication_year: nil)
      @id = id
      @name = name
      @publication_year = publication_year
    end
  end

  class Game
    def initialize(id, name, thumbnail_url: nil, image_url: nil)
      @id = id
      @image_url = image_url
      @name = name
      @thumbnail_url = thumbnail_url
      @versions = []
    end

    def add_version(version)
      @versions[] = version
    end

    def self.for_user(user, seed: false, attempts_count: 100, delay_seconds: 5)
      unless user.instance_of?(::User) && !user.bgg_username.empty?
        print "Unable to fetch BGG game collection for specified user, exiting...\n"
        return
      end
      username = user.bgg_username

      url = "#{BASE_URL}/collection"
      params = { username:, own: 1, version: 1 }

      http_statuses = Rack::Utils::SYMBOL_TO_STATUS_CODE
      response = nil
      attempts_count.times do |i|
        base_message = "Attempt ##{i + 1}: "
        begin
          response = RestClient.get(url, { params: })
        rescue RestClient::ExceptionWithResponse
          print "#{base_message}Exception encountered! - HTTP #{response.code}\n"
          next
        end

        case response.code
        when http_statuses[:accepted]
          print "#{base_message}Request accepted, processing...\n"
          sleep(delay_seconds)
          next
        when http_statuses[:ok]
          print "#{base_message}Request complete!\n"
          break
        else
          print "#{base_message}HTTP #{response.code} encountered, continuing...\n"
          sleep(delay_seconds)
          next
        end
      end

      unless response&.code == http_statuses[:ok]
        print "UNABLE TO GET SUCCESSFUL RESPONSE, EXITING...\n"
        return
      end

      items = Hash.from_xml(response.body)

      print 'Processing games'
      bgg_games = items.dig('items', 'item')
      bgg_games.map do |bgg_game|
        print '.'
        bgg_id = bgg_game['objectid']&.to_i
        next unless bgg_id

        name = bgg_game['name']
        image_url = bgg_game['image']
        thumbnail_url = bgg_game['thumbnail']

        game = if seed
                 ::Game.find_or_create_by!(bgg_id:) do |g|
                   g.name = name
                   g.bgg_image_url = image_url
                   g.bgg_thumbnail_url = thumbnail_url
                 end
               else
                 new(bgg_id, name, image_url:, thumbnail_url:)
               end

        bgg_versions = bgg_game.dig('version', 'item')
        if (!bgg_versions || bgg_versions.empty?) && seed
          copy = ::Copy.find_or_create_by!(holder: user, game:) do |c|
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
            print "Unable to derive ID from game version, skipping...\n"
            next
          end

          names = bgg_version['name']
          names = [names] unless names.instance_of?(Array)
          name = names.find { |n| n['type'] == 'primary' }['value']
          publication_year = bgg_version.dig('yearpublished', 'value')&.to_i

          if seed
            version = ::Version.find_or_create_by!(bgg_id:) do |v|
              v.game = game
              v.name = name
              v.publication_year = publication_year
              # pp v
            end
            copy = ::Copy.find_or_create_by!(holder: user, game:, version: nil) do |c|
              c.version = version
              # pp c
            end
            copy.ownerships.find_or_create_by!(owner: user) do |o|
              # pp o
            end
          else
            version = Version.new(bgg_id, name, publication_year:)
            game.add_version(version)
          end
        end
      end
    end
  end
end
