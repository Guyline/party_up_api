class V1::Oauth::AccessTokensController < Doorkeeper::TokensController
  include V1::Concerns::HandlesAccessTokens

  before_action :access_token_params,
    only: [:create_user_token]

  def create_user_token
    user = User.find_by(email: params.dig(:data, :email))
    if user.nil?
      BCrypt::Password.create(params.dig(:data, :password))
      raise ActiveRecord::RecordInvalid
    end
    access_token = find_or_create_token(user)

    render_response(access_token)
  end

  protected

  def access_token_params
    params.expect(
      data: [
        :email,
        :password
      ]
    ).require([
      :email,
      :password
    ])
  end
end
