class Copy < ApplicationRecord
  CONDITIONS = [
    CONDITION_NEW = 'new'.freeze,
    CONDITION_EXCELLENT = 'excellent'.freeze,
    CONDITION_GOOD = 'good'.freeze,
    CONDITION_FAIR = 'fair'.freeze,
    CONDITION_POOR = 'poor'.freeze,
    CONDITION_UNKNOWN = 'unknown'.freeze
  ].freeze

  after_initialize do |copy|
    copy.condition ||= CONDITION_UNKNOWN
  end

  validates :version_id,
            if: :version_id_changed?,
            inclusion: {
              in: ->(copy) { copy.playable&.versions&.pluck(:id) }
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

  belongs_to :playable,
             inverse_of: :copies,
             required: true
  belongs_to :holder,
             class_name: 'User',
             inverse_of: :held_copies,
             optional: true
  belongs_to :version,
             inverse_of: :copies,
             optional: true

  has_many :ownerships, inverse_of: :copy
  has_many :owners, through: :ownerships, source: :owner

  delegate :name,
           :bgg_id,
           to: :version,
           prefix: true,
           allow_nil: true
  delegate :name,
           :bgg_id,
           to: :playable,
           prefix: true,
           allow_nil: true

  def playable_type
    playable&.readable_type
  end
end
