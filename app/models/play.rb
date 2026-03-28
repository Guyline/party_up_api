class Play < ApplicationRecord
  include HasPublicId
  include StripsAttributes

  self.public_id_prefix = "ply"

  FAMILIARITIES = [
    FAMILIARITY_VERY_LOW = 1,
    FAMILIARITY_LOW = 2,
    FAMILIARITY_FAIR = 3,
    FAMILIARITY_HIGH = 4,
    FAMILIARITY_VERY_HIGH = 5
  ]

  PRIORITIES = [
    PRIORITY_VERY_LOW = 1,
    PRIORITY_LOW = 2,
    PRIORITY_FAIR = 3,
    PRIORITY_HIGH = 4,
    PRIORITY_VERY_HIGH = 5
  ]

  enum :familiarity,
    {
      very_low: FAMILIARITY_VERY_LOW,
      low: FAMILIARITY_LOW,
      fair: FAMILIARITY_FAIR,
      high: FAMILIARITY_HIGH,
      very_high: FAMILIARITY_VERY_HIGH
    },
    prefix: true,
    validate: {
      allow_nil: true
    }
  enum :priority,
    {
      very_low: PRIORITY_VERY_LOW,
      low: PRIORITY_LOW,
      fair: PRIORITY_FAIR,
      high: PRIORITY_HIGH,
      very_high: PRIORITY_VERY_HIGH
    },
    prefix: true,
    validate: {
      allow_nil: true
    }

  belongs_to :meetup
  belongs_to :item
  belongs_to :copy,
    optional: true
  belongs_to :proposer,
    class_name: User.name.to_s
  belongs_to :holder,
    class_name: User.name.to_s,
    optional: true
  belongs_to :primary_instructor,
    class_name: User.name.to_s,
    optional: true

  validates :meetup_id,
    uniqueness: {
      scope: :item_id
    }
  validates :item_id,
    comparison: {
      equal_to: ->(play) {
        play.copy&.item_id
      }
    },
    unless: -> { copy_id.nil? }
  validates :proposer_notes,
    allow_nil: true,
    length: {
      maximum: 20_000,
      minimum: 1
    }
end
