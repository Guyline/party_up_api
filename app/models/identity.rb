class Identity < ApplicationRecord
  PROVIDERS = [
    PROVIDER_GOOGLE = "google"
  ].freeze

  encrypts :token,
    deterministic: true
  encrypts :secret,
    deterministic: true
  encrypts :refresh_token,
    deterministic: true

  belongs_to :user,
    optional: true

  validates :email,
    presence: true,
    format: URI::MailTo::EMAIL_REGEXP
  validates :provider,
    inclusion: {
      in: PROVIDERS
    }
  validates :uid,
    uniqueness: {
      scope: [
        :provider
      ]
    }
end
