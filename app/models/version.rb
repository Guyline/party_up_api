class Version < ApplicationRecord
  include HasPublicId

  self.public_id_prefix = "vsn"

  validates :bgg_id,
    presence: true,
    uniqueness: true
  validates :name,
    presence: true

  belongs_to :item,
    inverse_of: :versions,
    optional: false

  has_many :copies,
    inverse_of: :version
  has_many :ownerships,
    through: :copies,
    source: :ownerships
  has_many :owners,
    -> { distinct },
    through: :ownerships,
    source: :owner

  delegate :bgg_id,
    :name,
    :type,
    to: :item,
    prefix: true,
    allow_nil: true
end
