##
# The User class is a representation of an individual using this application
class User < ApplicationRecord
  devise :database_authenticatable,
         :omniauthable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         omniauth_providers: [:google]

  has_many :ownerships, inverse_of: :owner

  has_many :owned_copies, through: :ownerships, source: :copy
  has_many :owned_games, -> { distinct }, through: :owned_copies, source: :game
  has_many :owned_versions, through: :owned_copies, source: :version

  has_many :held_copies, class_name: 'Copy', foreign_key: :holder_id, inverse_of: :holder
  has_many :held_games, -> { distinct }, through: :held_copies, source: :game
  has_many :held_versions, through: :held_copies, source: :version
end
