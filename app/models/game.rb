class Game < ApplicationRecord
  validates :name, presence: true
  validates :bgg_id, uniqueness: true, allow_nil: true

  has_many :versions, inverse_of: :game
  has_many :copies, inverse_of: :game

  has_many :holders, -> { distinct }, through: :copies, source: :holder

  has_many :ownerships, through: :copies, source: :ownerships
  has_many :owners, -> { distinct }, through: :ownerships, source: :owner
end
