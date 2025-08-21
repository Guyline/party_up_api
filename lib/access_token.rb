class AccessToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
    end

    protected

    def secret_key
      Rails.application.credentials.jwt.secret_key!
    end
  end
end
