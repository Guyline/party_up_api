class UserLocation < ApplicationRecord
  include Discard::Model

  default_scope -> { kept }

  validates :location_id, uniqueness: {scope: :user_id}

  belongs_to :user, optional: false, inverse_of: :user_locations
  belongs_to :location, optional: false, inverse_of: :user_locations
end
