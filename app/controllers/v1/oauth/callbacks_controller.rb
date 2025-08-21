class V1::Oauth::CallbacksController < V1::ApplicationController
  def google
    token = params[:credential]
    client_id = Rails.application.credentials.dig(:oauth, :google, :client_id)
    token = Google::Auth::IDTokens.verify_oidc(token, aud: client_id)

    user = User.from_google_id_token(token)
    expires_in = Doorkeeper.config.access_token_expires_in

    access_token = Doorkeeper::AccessToken.find_or_create_for(
      application: doorkeeper_token.application,
      expires_in: (expires_in == Float::INFINITY) ? nil : expires_in,
      id: ApplicationRecord.generate_primary_key,
      resource_owner: user,
      scopes: "",
      use_refresh_token: Doorkeeper.config.refresh_token_enabled?
    )

    Rails.logger.debug access_token

    render json: {
      access_token: access_token.token,
      created_at: access_token.created_at,
      expires_in: access_token.expires_in,
      refresh_token: access_token.refresh_token,
      token_type: "Bearer"
    }
  end
end
