class V1::CopyResource < V1::BaseResource
  has_one :holder,
    class_name: User.name.to_s,
    relation_name: :holder
  has_one :playable,
    polymorphic: true,
    relation_name: :playable
end
