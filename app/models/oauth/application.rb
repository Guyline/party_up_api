module Oauth
  class Application < ApplicationRecord
    include ::Doorkeeper::Orm::ActiveRecord::Mixins::Application
  end
end
