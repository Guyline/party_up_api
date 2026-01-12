module Oauth
  class AccessToken < ApplicationRecord
    include ::Doorkeeper::Orm::ActiveRecord::Mixins::AccessToken
  end
end
