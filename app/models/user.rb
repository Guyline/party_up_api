##
# The User class is a representation of an individual using this application
#
class User < ApplicationRecord
  include HasPublicId

  self.public_id_prefix = "usr"

  devise :database_authenticatable,
    :recoverable,
    :registerable,
    :validatable
  # devise :omniauthable,
  #  omniauth_providers: [:google]

  has_many :access_grants,
    class_name: Doorkeeper.config.access_grant_class.to_s,
    foreign_key: :resource_owner_id,
    dependent: :delete_all

  has_many :access_tokens,
    class_name: Doorkeeper.config.access_token_class.to_s,
    dependent: :delete_all,
    foreign_key: :resource_owner_id,
    inverse_of: :resource_owner

  has_many :identities

  #############
  # Locations #
  #############

  has_many :user_locations,
    inverse_of: :user
  has_many :managed_locations,
    through: :user_locations,
    source: :location

  ##############
  # Ownerships #
  ##############

  has_many :ownerships,
    inverse_of: :owner

  ##########
  # Copies #
  ##########

  has_many :held_copies,
    class_name: "Copy",
    foreign_key: :holder_id,
    inverse_of: :holder
  has_many :owned_copies,
    through: :ownerships,
    source: :copy

  #########
  # Items #
  #########

  has_many :held_items,
    -> { distinct },
    through: :held_copies,
    source: :item
  has_many :owned_items,
    -> { distinct },
    through: :owned_copies,
    source: :item

  ############
  # Versions #
  ############

  has_many :held_versions,
    -> { distinct },
    through: :held_copies,
    source: :version
  has_many :owned_versions,
    -> { distinct },
    through: :owned_copies,
    source: :version

  ###########
  # Meetups #
  ###########

  has_many :created_meetups,
    class_name: Meetup.name.to_s,
    inverse_of: :creator

  ###########
  # Invites #
  ###########

  has_many :sent_invites,
    class_name: Invite.name.to_s,
    inverse_of: :inviter
  has_many :received_invites,
    class_name: Invite.name.to_s,
    inverse_of: :invitee

  class << self
    def from_google_id_token(token, refresh_token: nil, expires_at: nil)
      provider = Identity::PROVIDER_GOOGLE
      email, first_name, last_name, uid = token.values_at("email", "given_name", "family_name", "sub")
      email&.downcase!

      identity = Identity.where(provider:, uid:).first
      unless identity
        user = find_for_database_authentication(email:)
        user ||= User.create!(
          email:,
          first_name:,
          last_name:,
          password: Devise.friendly_token[0, 20]
        )
        identity = user.identities.new(
          provider:,
          uid:
        )
      end

      identity.email ||= email
      identity.first_name ||= first_name
      identity.last_name ||= last_name

      identity.token = token
      identity.refresh_token = refresh_token
      identity.token_expires_at = expires_at

      identity.save!

      identity.user
    end

    ##
    # Find/create a user with a new/existing identity pertaining to auth information
    # See: https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
    #
    def from_omniauth(auth)
      Rails.logger.debug(auth.to_yaml)
      provider = auth["provider"]
      uid = auth["uid"]
      info = auth["info"]

      identity = Identity.where(provider:, uid:).first
      unless identity
        email = info.email.downcase
        user = find_for_database_authentication(email:)
        user ||= User.create!(
          email:,
          password: Devise.friendly_token[0, 20]
        )
        identity = user.identities.new(
          provider:,
          uid:
        )
      end
      identity.first_name ||= info["first_name"]
      identity.last_name ||= info["last_name"]
      identity.email ||= info["email"]

      credentials = auth.credentials
      identity.token = credentials["token"]
      identity.refresh_token = credentials["refresh_token"]
      identity.token_expires_at = Time.zone.at(credentials["expires_at"]).to_datetime
      identity.save!

      identity.user
    end
  end
end
