class V1::Oauth::CallbacksController < V1::ApplicationController
  skip_before_action :doorkeeper_authorize!,
    only: [
      :google
    ]

  def google
    authorization_code = params[:code]
    callback_uri = doorkeeper_token&.application&.redirect_uri || request.base_url + request.path
    Utilities::Oauth.google_authorize(authorization_code, callback_uri) => {
      expires_at:,
      id_token:,
      refresh_token:
    }

    user = User.from_google_id_token(id_token, refresh_token:, expires_at:)
    expires_in = Doorkeeper.config.access_token_expires_in

    access_token = Oauth::AccessToken.find_or_create_for(
      application: doorkeeper_token&.application,
      expires_in: (expires_in == Float::INFINITY) ? nil : expires_in,
      resource_owner: user,
      scopes: "",
      use_refresh_token: Doorkeeper.config.refresh_token_enabled?
    )

    render json: {
      access_token: access_token.token,
      created_at: access_token.created_at,
      expires_in: access_token.expires_in,
      refresh_token: access_token.refresh_token,
      token_type: "Bearer"
    }
  end
end
