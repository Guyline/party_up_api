class Identity < ApplicationRecord
  encrypts :token, deterministic: true
  encrypts :secret, deterministic: true
  encrypts :refresh_token, deterministic: true

  belongs_to :user, optional: true

  validates :uid, uniqueness: {scope: [:provider]}
end
