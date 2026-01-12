# A query represents the entity used to make queries to BGG and iterate over results
module BoardGameGeek
  class Query
    BASE_URL = "https://boardgamegeek.com/xmlapi2"

    attr_accessor :attempts_count,
      :delay_seconds,
      :params,
      :url

    def initialize(url: nil, params: {}, attempts_count: 100, delay_seconds: 5)
      @attempts_count = attempts_count
      @delay_seconds = delay_seconds
      @params = params
      @url = [
        BASE_URL,
        url || "thing"
      ].join("/")
    end

    def find_each(&)
      return enum_for(:find_each) unless block_given?

      response = execute
      raise "UNABLE TO GET SUCCESSFUL RESPONSE." unless response&.code == 200

      bgg_items = Hash.from_xml(response.body).dig("items", "item")
      bgg_items = [bgg_items] unless bgg_items.is_a?(Array)
      raise "UNABLE TO PARSE BGG RESPONSE." unless bgg_items

      playables = bgg_items.map do |bgg_item|
        self.class.send(:parse_item, bgg_item)
      end
      playables.each(&)
    end

    class << self
      def find(id)
        raise(ArgumentError, "ID invalid") unless id.is_a?(Integer) && id.positive?

        query = new(
          url: "thing",
          params: {
            id:
          }
        )
        response = query.send(:execute)
        raise "UNABLE TO GET SUCCESSFUL RESPONSE." unless response&.code == 200

        bgg_items = Hash.from_xml(response.body).dig("items", "item")
        bgg_item = bgg_items.is_a?(Array) ? bgg_items.first : bgg_items
        raise "UNABLE TO PARSE BGG RESPONSE." unless bgg_item

        parse_item(bgg_item)
      end

      protected

      def parse_item(bgg_item)
        # Rails.logger.debug(JSON.pretty_generate(bgg_item))

        id = bgg_item["id"]&.to_i || bgg_item["objectid"]&.to_i
        raise "Unable to find ID in BGG response (JSON: #{bgg_item.to_json})" unless id&.positive?

        type = bgg_item["type"]
        type_map = {
          "boardgame" => BoardGameGeek::Game,
          "boardgameexpansion" => BoardGameGeek::Expansion
        }
        klass = type_map[type] || BoardGameGeek::Thing

        instance = klass.find(id, cached_only: true)
        unless instance
          name = bgg_item["name"]
          name = name.find { |n| n["type"] == "primary" } if name.is_a?(Array)
          name = name["value"] if name.is_a?(Hash)
          raise "Unable to determine name in BGG response (JSON: #{bgg_item.to_json})" unless name.is_a?(String)

          image_url = bgg_item["image"]
          thumbnail_url = bgg_item["thumbnail"]

          # Rails.logger.debug("CREATING #{klass.name}: " + JSON.pretty_generate({id:, name:, image_url:, thumbnail_url:}))

          instance = klass.new(id:, name:, image_url:, thumbnail_url:)
        end

        bgg_links = bgg_item["link"] || []
        bgg_expansions = bgg_links.filter { |bgg_link| bgg_link["type"] == "boardgameexpansion" }
        bgg_expansions.each do |bgg_expansion|
          expansion_id = bgg_expansion["id"]&.to_i
          next unless expansion_id&.positive?

          expansion_name = bgg_expansion["value"]

          if instance.is_a?(BoardGameGeek::Expansion) && bgg_expansion["inbound"]
            thing = BoardGameGeek::Thing.find(expansion_id, cached_only: true)
            thing ||= BoardGameGeek::Thing.new(id: expansion_id, name: expansion_name)
            instance.add_expandable(thing)
          else
            expansion = BoardGameGeek::Expansion.find(expansion_id, cached_only: true)
            expansion ||= BoardGameGeek::Expansion.new(id: expansion_id, name: expansion_name)
            instance.add_expansion(expansion)
          end
        end

        instance
      end
    end

    protected

    def execute(method: :get, url: nil, params: nil)
      http_statuses = Rack::Utils::SYMBOL_TO_STATUS_CODE
      url ||= @url
      params ||= @params
      headers = {
        params:
      }
      Rails.logger.debug { {method:, url:, headers:} }

      auth_token = Rails.application.credentials.dig(:bgg, :access_token)
      headers["Authorization"] = "Bearer #{auth_token}" if auth_token

      @attempts_count.times do |i|
        base_message = "Attempt ##{i + 1}"
        begin
          response = RestClient::Request.execute(
            method:,
            url:,
            headers:
          )
        rescue RestClient::ExceptionWithResponse => e
          Rails.logger.error "#{base_message}: Exception encountered! - HTTP #{e.http_code}"
          Rails.logger.error e.to_s
          sleep(@delay_seconds)
          next
        end

        case response.code
        when http_statuses[:accepted]
          Rails.logger.info "#{base_message}: Request accepted, processing..."
          sleep(@delay_seconds)
          next
        when http_statuses[:ok]
          Rails.logger.info "#{base_message}: Request complete!"
          return response
        when http_statuses[:too_many_requests]
          Rails.logger.error "#{base_message}: Too many requests, stopping!"
          return nil
        else
          Rails.logger.error "#{base_message}: HTTP #{response.code} encountered, continuing..."
          sleep(@delay_seconds)
          next
        end
      end

      nil
    end
  end
end
