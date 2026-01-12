module Oauth
  class AccessGrant < ApplicationRecord
    include ::Doorkeeper::Orm::ActiveRecord::Mixins::AccessGrant
  end
end
