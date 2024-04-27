class Copy < ApplicationRecord
  CONDITIONS = [
    CONDITION_NEW = 'new'.freeze,
    CONDITION_EXCELLENT = 'excellent'.freeze,
    CONDITION_GOOD = 'good'.freeze,
    CONDITION_FAIR = 'fair'.freeze,
    CONDITION_POOR = 'poor'.freeze,
    CONDITION_UNKNOWN = 'unknown'.freeze
  ].freeze

  validates :version_id,
            if: :version_id_changed?,
            inclusion: {
              in: ->(copy) { copy.game&.versions&.pluck(:id) }
            },
            allow_nil: true
  validates :condition,
            presence: true,
            inclusion: {
              in: CONDITIONS
            }
  validates :asking_price,
            numericality: {
              greater_than: 0,
              less_than: 99_999.99
            },
            allow_nil: true
  validates :asking_currency,
            inclusion: {
              in: ['USD']
            },
            allow_nil: true

  belongs_to :game, required: true, inverse_of: :copies
  belongs_to :holder, optional: true, class_name: 'User', inverse_of: :held_copies
  belongs_to :version, optional: true, inverse_of: :copies

  has_many :ownerships, inverse_of: :copy
  has_many :owners, through: :ownerships, source: :owner

  delegate :name, :bgg_id, to: :version, prefix: true, allow_nil: true
  delegate :name, :bgg_id, to: :game, prefix: true, allow_nil: true

  after_initialize do |copy|
    copy.condition ||= CONDITION_UNKNOWN
  end
end
