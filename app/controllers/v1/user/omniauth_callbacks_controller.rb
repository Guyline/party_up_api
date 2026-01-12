class V1::User::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google
    Rails.logger.debug "REQUESTING CALLBACK ENDPOINT"
    Rails.logger.debug request.env

    user = User.from_omniauth(auth)
    application = server.client

    Oauth::AccessToken.find_or_create_for!(
      application:,
      resource_owner: user,
      scopes: application.scopes
    )
  end

  private

  def auth
    request.env["omniauth.auth"]
  end
end
