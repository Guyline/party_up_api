module GoogleMaps
  class Client
    class << self
      def query(query)
        url = "https://places.googleapis.com/v1/places:searchText"
        begin
          response = execute_request(:post, url, payload: {textQuery: query})
          results = JSON.parse(response&.body) || {}
          pp results
          results["places"]
        rescue RestClient::Exception => e
          puts e.http_headers
          puts e.http_body
        end
      end

      protected

      def execute_request(method, url, headers: {}, payload: {}, field_mask: ["places.id", "places.name"])
        headers[:"X-Goog-Api-Key"] = api_key
        headers[:"X-Goog-FieldMask"] = field_mask.join(",")
        RestClient::Request.execute(method:, url:, headers:, payload:)
      end

      def api_key
        Rails.application.credentials.google_places.api_key
      end
    end
  end
end
