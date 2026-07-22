module AccessTokenResponse
  def body
    {
      data: {
        access_token: @token[:token],
        created_at: @token[:created_at],
        expires_in: @token[:expires_in],
        refresh_token: @token[:refresh_token],
        token_type: "Bearer"
      }
    }.to_json
  end
end
