module Utilities
  class Oauth
    class << self
      ##
      # Verifies and exchanges authorization code from Google identity provider.
      #
      # @param [String] code The authorization code from the OAuth callback
      #
      # @return [Hash]
      #   expires_at: DateTime of the estimated expiration time of identity token expiration
      #   id_token: Contents of decoded JWT payload from Google identity provider
      #   refresh_token: Token to be used to refresh ID token
      #   scopes: Array of scopes authorized by the ID token
      #
      def google_authorize(authorization_code, callback_uri)
        Rails.logger.debug({authorization_code:, callback_uri:}.to_json)
        client_id = Google::Auth::ClientId.new(
          Rails.application.credentials.dig(:oauth, :google, :client_id),
          Rails.application.credentials.dig(:oauth, :google, :client_secret)
        )
        scope = Google::Auth::ScopeUtil::ALIASES.keys
        authorizer = Google::Auth::UserAuthorizer.new(
          client_id,
          scope,
          nil,
          callback_uri:
        )
        credentials = authorizer.get_credentials_from_code(code: authorization_code)
        encoded_token = credentials.id_token
        expires_in_seconds = credentials.expires_in

        {
          expires_at: expires_in_seconds.is_a?(Integer) ?
            DateTime.now + expires_in_seconds.seconds :
            nil,
          id_token: Google::Auth::IDTokens.verify_oidc(
            encoded_token,
            aud: client_id.id
          ),
          refresh_token: credentials.refresh_token,
          scopes: credentials.scope.split
        }
      end
    end
  end
end
