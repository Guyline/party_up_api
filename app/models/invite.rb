class Invite < ApplicationRecord
  include HasPublicId

  self.public_id_prefix = "inv"

  STATUSES = [
    STATUS_PENDING = "pending",
    STATUS_ACCEPTED = "accepted",
    STATUS_REJECTED = "rejected"
  ].freeze

  after_save :update_meetup_attendees_count

  scope :pending, -> {
    where(accepted_at: nil, rejected_at: nil)
  }
  scope :accepted, -> {
    where(rejected_at: nil).where.not(accepted_at: nil)
  }
  scope :rejected, -> {
    where.not(rejected_at: nil)
  }

  belongs_to :meetup,
    counter_cache: true
  belongs_to :invitee,
    class_name: User.name.to_s,
    inverse_of: :received_invites
  belongs_to :inviter,
    class_name: User.name.to_s,
    inverse_of: :sent_invites

  validates :meetup,
    uniqueness: {
      scope: :invitee
    }

  def rejected?
    !rejected_at.nil?
  end

  def accepted?
    !rejected? && !accepted_at.nil?
  end

  def pending?
    !(accepted? || rejected?)
  end

  def status
    if rejected?
      STATUS_REJECTED
    elsif accepted?
      STATUS_ACCEPTED
    else
      STATUS_PENDING
    end
  end

  protected

  def update_meetup_attendees_count
    previously_accepted = !accepted_at_previously_was.nil? &&
      rejected_at_previously_was.nil?

    if !previously_accepted && accepted?
      meetup&.increment!(:attendees_count)
    elsif previously_accepted && !accepted?
      meetup&.decrement!(:attendees_count)
    end
  end
end
