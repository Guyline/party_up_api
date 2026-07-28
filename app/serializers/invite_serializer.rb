class InviteSerializer
  include JSONAPI::Serializer

  set_type :invite
  set_id :public_id

  attributes :is_host,
    :status

  attribute :timestamps do |i|
    {
      accepted_at: i.accepted_at,
      created_at: i.created_at,
      rejected_at: i.rejected_at,
      updated_at: i.updated_at
    }
  end

  belongs_to :invitee,
    serializer: UserSerializer,
    id_method_name: :invitee_public_id
  belongs_to :inviter,
    serializer: UserSerializer,
    id_method_name: :inviter_public_id
  belongs_to :meetup,
    id_method_name: :meetup_public_id
end
