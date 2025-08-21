# A query represents the entity used to make queries to BGG and iterate over results
class BoardGameGeek::Query
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
      id = bgg_item["id"]&.to_i || bgg_item["objectid"]&.to_i
      raise "Unable to find ID in BGG response (JSON: #{bgg_item.to_json})" unless id&.positive?

      type_map = {
        "boardgame" => Game,
        "boardgameexpansion" => Expansion
      }
      type = bgg_item["type"]
      klass = type_map[type] || Playable

      instance = klass.find(id, fresh: false)

      unless instance
        name = bgg_item["name"]
        name = name.find { |n| n["type"] == "primary" } if name.is_a?(Array)
        name = name["value"] if name.is_a?(Hash)
        raise "Unable to determine name in BGG response (JSON: #{bgg_item.to_json})" unless name.is_a?(String)

        instance = klass.new(id: id, name: name)
      end

      bgg_links = bgg_item["link"] || []
      bgg_expansions = bgg_links.filter { |bgg_link| bgg_link["type"] == "boardgameexpansion" }
      bgg_expansions.each do |bgg_expansion|
        expansion_id = bgg_expansion["id"]&.to_i
        next unless expansion_id&.positive?

        expansion_name = bgg_expansion["value"]

        if instance.is_a?(Expansion) && bgg_expansion["inbound"]
          game = Game.find(expansion_id, fresh: false)
          game ||= Game.new(id: expansion_id, name: expansion_name)
          instance.add_expandable(game)
        else
          expansion = Expansion.find(expansion_id, fresh: false)
          expansion ||= Expansion.new(id: expansion_id, name: expansion_name)
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

    @attempts_count.times do |i|
      base_message = "Attempt ##{i + 1}"
      begin
        response = RestClient::Request.execute(method:, url:, headers: {params:})
      rescue RestClient::ExceptionWithResponse => e
        print "#{base_message}: Exception encountered! - HTTP #{e.http_code}"
        pp e.http_body
        sleep(@delay_seconds)
        next
      end

      case response.code
      when http_statuses[:accepted]
        print "#{base_message}: Request accepted, processing...\n"
        sleep(@delay_seconds)
        next
      when http_statuses[:ok]
        print "#{base_message}: Request complete!\n"
        return response
      else
        print "#{base_message}: HTTP #{response.code} encountered, continuing...\n"
        sleep(@delay_seconds)
        next
      end
    end

    nil
  end
end
