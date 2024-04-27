class Version < ApplicationRecord
  validates :name, presence: true
  validates :bgg_id, presence: true, uniqueness: true

  belongs_to :game, required: true, inverse_of: :versions

  has_many :copies, inverse_of: :version
  has_many :ownerships, through: :copies, source: :ownerships
  has_many :owners, -> { distinct }, through: :ownerships, source: :owner

  delegate :name, :bgg_id, to: :game, prefix: true, allow_nil: true
end
