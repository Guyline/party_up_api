class Meetup < ApplicationRecord
  include HasPublicId
  include StripsAttributes

  self.public_id_prefix = "mtp"

  EXCLUSIVITIES = [
    EXCLUSIVITY_CREATOR = "creator_invite",
    EXCLUSIVITY_HOST = "host_invite",
    EXCLUSIVITY_ATTENDEE = "attendee_invite",
    EXCLUSIVITY_OPEN = "open"
  ]

  belongs_to :creator,
    class_name: User.name.to_s,
    inverse_of: :created_meetups
  belongs_to :location,
    optional: true

  has_many :invites,
    class_name: Invite.name.to_s
  has_many :invitees,
    through: :invites,
    source: :invitee
  has_many :inviters,
    through: :invites,
    source: :inviter

  validates :exclusivity,
    inclusion: {
      in: EXCLUSIVITIES
    }
  validates :description,
    allow_nil: true,
    length: {
      maximum: 20_000,
      minimum: 1
    }
  validates :starts_at,
    presence: true
  validates :ends_at,
    presence: true
  validates :ends_at,
    comparison: {
      greater_than: :starts_at
    },
    if: -> { starts_at.is_a?(Time) && ends_at.is_a?(Time) }
end
