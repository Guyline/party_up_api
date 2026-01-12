class Location < ApplicationRecord
  include HasPublicId

  self.public_id_prefix = "loc"

  before_save do
    set_google_place_id if changed?
  end

  has_many :copies,
    inverse_of: :location

  has_many :user_locations,
    inverse_of: :location
  has_many :managers,
    through: :user_locations,
    source: :user

  validates :number,
    :street,
    :city,
    :state,
    :postal_code,
    :country,
    presence: true

  validates :country,
    inclusion: {
      in: ISO3166::Country.codes
    }
  validates :state,
    inclusion: {
      in: ->(location) { ISO3166::Country[location.country].subdivisions }
    },
    if: ->(location) { location.country.present? && ISO3166::Country.codes.include?(location.country) }

  def address
    [
      number,
      street,
      city,
      state,
      postal_code,
      country
    ].join(" ")
  end

  protected

  def set_google_place_id
    google_places = GoogleMaps::Client.query(address)
    self.google_place_id = (google_places.count == 1) ? google_places&.first&.[]("id") : null
  end
end
