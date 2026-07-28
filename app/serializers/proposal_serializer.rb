class ProposalSerializer
  include JSONAPI::Serializer

  set_type :proposal
  set_id :public_id

  attributes :familiarity,
    :item_name,
    :priority,
    :proposer_notes

  attribute :timestamps do |i|
    {
      created_at: i.created_at,
      updated_at: i.updated_at
    }
  end

  belongs_to :meetup,
    serializer: MeetupSerializer,
    id_method_name: :meetup_public_id
  belongs_to :item,
    serializer: ItemSerializer,
    id_method_name: :item_public_id
end
