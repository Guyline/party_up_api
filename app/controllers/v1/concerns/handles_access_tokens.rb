module V1::Concerns::HandlesAccessTokens
  extend ActiveSupport::Concern

  included do
    protected

    def find_or_create_token(user)
      expires_in = Doorkeeper.config.access_token_expires_in

      Oauth::AccessToken.find_or_create_for(
        application: doorkeeper_token&.application,
        expires_in: (expires_in == Float::INFINITY) ? nil : expires_in,
        resource_owner: user,
        scopes: "",
        use_refresh_token: Doorkeeper.config.refresh_token_enabled?
      )
    end

    def render_response(access_token)
      raise "Access token expected" unless access_token.is_a?(Oauth::AccessToken)

      render json: {
        data: {
          access_token: access_token.token,
          created_at: access_token.created_at,
          expires_in: access_token.expires_in,
          refresh_token: access_token.refresh_token,
          token_type: "Bearer"
        }
      }
    end
  end
end
