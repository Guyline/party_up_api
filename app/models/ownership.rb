class Ownership < ApplicationRecord
  include Discard::Model
  include HasPublicId

  self.public_id_prefix = "own"

  default_scope -> { kept.includes(:owner, :copy) }

  validates :owner_id,
    uniqueness: {
      scope: :copy_id
    }

  belongs_to :copy,
    optional: false,
    inverse_of: :ownerships
  belongs_to :owner,
    optional: false,
    class_name: "User",
    inverse_of: :ownerships

  delegate :username,
    to: :owner,
    prefix: true,
    allow_nil: true
  delegate :item_bgg_id,
    :item_name,
    :version_bgg_id,
    :version_name,
    to: :copy,
    prefix: false,
    allow_nil: true
  delegate :condition,
    to: :copy,
    prefix: true,
    allow_nil: true
end
