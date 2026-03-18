module Oauth
  class AccessToken < ApplicationRecord
    include ::Doorkeeper::Orm::ActiveRecord::Mixins::AccessToken

    belongs_to :resource_owner,
      class_name: "User",
      inverse_of: :access_tokens

    # JSON representation of the Access Token instance.
    #
    # @return [Hash] hash with token data
    def as_json(_options = {})
      {
        application: {
          uid: application.try(:uid)
        },
        created_at: created_at.to_i,
        expires_in: expires_in_seconds,
        resource_owner_id: resource_owner&.public_id,
        scope: scopes
      }
    end
  end
end
