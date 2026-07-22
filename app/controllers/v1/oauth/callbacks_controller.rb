class V1::Oauth::CallbacksController < V1::ApplicationController
  include V1::Concerns::HandlesAccessTokens

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
    access_token = find_or_create_token(user)

    render_response(access_token)
  end
end
