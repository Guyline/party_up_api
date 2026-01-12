class V1::ExpansionResource < V1::PlayableResource
  model_name Expansion.name

  has_many :expandables,
    always_include_linkage_data: true,
    polymorphic: true
end
