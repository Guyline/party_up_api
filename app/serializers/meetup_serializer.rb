class MeetupSerializer
  include JSONAPI::Serializer

  set_type :meetup
  set_id :public_id

  attributes :attendees_count,
    :description,
    :ends_at,
    :exclusivity,
    :invites_count,
    :is_public,
    :max_attendees_count,
    :min_attendees_count,
    :starts_at,
    :status

  attribute :timestamps do |m|
    {
      canceled_at: m.canceled_at,
      created_at: m.created_at,
      published_at: m.published_at,
      updated_at: m.updated_at
    }
  end

  belongs_to :creator,
    serializer: UserSerializer,
    id_method_name: :creator_public_id
  # belongs_to :location

  has_many :attendees,
    serializer: UserSerializer,
    id_method_name: :attendee_public_ids
  has_many :invites,
    id_method_name: :invite_public_ids
  # has_many :proposals
end
