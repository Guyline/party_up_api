module Playable
  extend ActiveSupport::Concern

  included do
    has_one :item,
      as: :playable,
      touch: true

    delegate :bgg_id,
      :bgg_image_url,
      :bgg_thumbnail_url,
      :copies,
      :expansions,
      :name,
      :owners,
      :versions,
      to: :item

    default_scope do
      includes(:item)
    end
  end
end
