class Ownership < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  validates :owner_id, uniqueness: { scope: :copy_id }

  belongs_to :copy, required: true, inverse_of: :ownerships
  belongs_to :owner, required: true, class_name: 'User', inverse_of: :ownerships

  delegate :username,
           to: :owner,
           prefix: true,
           allow_nil: true
  delegate :playable_bgg_id,
           :playable_name,
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
