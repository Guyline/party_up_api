class V1::PlayableResource < V1::BaseResource
  immutable

  attributes :bgg_id,
    :bgg_image_url,
    :bgg_thumbnail_url,
    :created_at,
    :name,
    :updated_at

  has_many :copies
  has_many :expansions,
    relation_name: :expansions
  has_many :holders,
    class_name: User.name.to_s,
    relation_name: :holders
  has_many :owners,
    class_name: User.name.to_s,
    relation_name: :owners
  has_many :ownerships
  has_many :versions

  class << self
    def default_sort
      [
        {
          field: "name",
          direction: :asc
        }
      ]
    end
  end
end
