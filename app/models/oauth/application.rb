class Oauth::Application < ApplicationRecord
  include ::Doorkeeper::Orm::ActiveRecord::Mixins::Application
end
