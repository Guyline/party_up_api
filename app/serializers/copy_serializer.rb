class CopySerializer
  include JSONAPI::Serializer

  set_type :copy
  set_id :public_id

  attributes :asking_currency,
    :asking_price,
    :condition,
    :is_borrowable,
    :is_playable,
    :is_purchaseable,
    :is_tradeable

  attribute :timestamps do |c|
    {
      created_at: c.created_at,
      updated_at: c.updated_at
    }
  end
end
