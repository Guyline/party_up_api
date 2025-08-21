class Version < ApplicationRecord
  validates :name, presence: true
  validates :bgg_id, presence: true, uniqueness: true

  belongs_to :playable,
    inverse_of: :versions,
    optional: false

  has_many :copies, inverse_of: :version
  has_many :ownerships, through: :copies, source: :ownerships
  has_many :owners, -> { distinct }, through: :ownerships, source: :owner

  delegate :name,
    :bgg_id,
    to: :playable,
    prefix: true,
    allow_nil: true

  def playable_type
    playable&.readable_type
  end
end
