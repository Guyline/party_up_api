class Copy < ApplicationRecord
  include HasPublicId

  self.public_id_prefix = "cpy"

  enum :condition,
    {
      unknown: "unknown",
      new: "new",
      excellent: "excellent",
      good: "good",
      fair: "fair",
      poor: "poor"
    },
    prefix: true

  after_initialize do |copy|
    copy.condition ||= :unknown
  end

  validates :version_id,
    if: :version_id_changed?,
    inclusion: {
      in: ->(copy) { copy.item&.versions&.pluck(:id) }
    },
    allow_nil: true
  validates :condition,
    presence: true,
    inclusion: {
      in: conditions.keys
    }
  validates :asking_currency,
    inclusion: {
      in: Money::Currency.map(&:iso_code)
    },
    allow_nil: true

  belongs_to :location,
    inverse_of: :copies,
    optional: true
  belongs_to :item,
    inverse_of: :copies,
    optional: false
  belongs_to :holder,
    class_name: "User",
    inverse_of: :held_copies,
    optional: true
  belongs_to :version,
    inverse_of: :copies,
    optional: true

  has_many :ownerships,
    inverse_of: :copy
  has_many :owners,
    through: :ownerships,
    source: :owner

  delegate :name,
    :bgg_id,
    to: :version,
    prefix: true,
    allow_nil: true
  delegate :bgg_id,
    :category,
    :name,
    to: :item,
    prefix: true,
    allow_nil: true

  monetize :asking_price_cents,
    with_model_currency: :asking_currency,
    numericality: {
      greater_than: 0,
      less_than_or_equal_to: 9_999_999
    },
    allow_nil: true

  scope :for_user, ->(user) {
    left_outer_joins(:ownerships)
      .where(
        "copies.holder_id = :user_id OR ownerships.owner_id = :user_id",
        user_id: user.id
      ).distinct
  }
end
