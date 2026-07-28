class Meetup < ApplicationRecord
  include HasPublicId
  include StripsAttributes

  self.public_id_prefix = "mtp"

  EXCLUSIVITIES = [
    EXCLUSIVITY_CREATOR = "creator_invite",
    EXCLUSIVITY_HOST = "host_invite",
    EXCLUSIVITY_ATTENDEE = "attendee_invite",
    EXCLUSIVITY_OPEN = "open"
  ].freeze

  STATUSES = [
    STATUS_CANCELED = "canceled",
    STATUS_PUBLISHED = "published",
    STATUS_UNPUBLISHED = "unpublished"
  ].freeze

  belongs_to :creator,
    class_name: User.name.to_s,
    inverse_of: :created_meetups
  belongs_to :location,
    optional: true,
    class_name: Location.name.to_s

  has_many :invites,
    class_name: Invite.name.to_s
  has_many :invitees,
    through: :invites,
    source: :invitee
  has_many :inviters,
    through: :invites,
    source: :inviter

  has_many :accepted_invites,
    -> { accepted },
    class_name: Invite.name.to_s
  has_many :attendees,
    through: :accepted_invites,
    source: :invitee

  has_many :proposals,
    class_name: Proposal.name.to_s
  has_many :proposed_items,
    through: :proposals,
    source: :item

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
    presence: true,
    unless: -> {
      published_at.nil?
    }
  validates :ends_at,
    presence: true,
    unless: -> {
      published_at.nil?
    }
  validates :ends_at,
    comparison: {
      greater_than: :starts_at
    },
    if: -> { starts_at.is_a?(Time) && ends_at.is_a?(Time) }

  delegate :public_id,
    to: :creator,
    prefix: true

  def canceled?
    !canceled_at.nil?
  end

  def published?
    !canceled? && !published_at.nil?
  end

  def unpublished?
    !canceled? && !published?
  end

  def status
    if canceled?
      STATUS_CANCELED
    elsif published?
      STATUS_PUBLISHED
    else
      STATUS_UNPUBLISHED
    end
  end

  def status=(value)
    case value
    when STATUS_UNPUBLISHED
      self.published_at = nil
      self.canceled_at = nil
    when STATUS_PUBLISHED
      self.published_at ||= DateTime.current
      self.canceled_at = nil
    when STATUS_CANCELED
      self.canceled_at = DateTime.current
    end
  end

  def attendee_public_ids
    attendees.pluck(:public_id)
  end

  def invite_public_ids
    invites.pluck(:public_id)
  end
end
