class ItemSerializer
  include JSONAPI::Serializer

  set_type :item
  set_id :public_id

  attributes :bgg_id,
    :bgg_image_url,
    :bgg_thumbnail_url,
    :category,
    :name

  attribute :timestamps do |i|
    {
      created_at: i.created_at,
      updated_at: i.updated_at
    }
  end

  has_many :expansions,
    serializer: ItemSerializer,
    id_method_name: :expansion_public_ids
  has_many :expandables,
    serializer: ItemSerializer,
    id_method_name: :expandable_public_ids
end
