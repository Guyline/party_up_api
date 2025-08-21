class PlayableExpansion < ApplicationRecord
  belongs_to :playable,
    optional: false
  belongs_to :expansion,
    class_name: "Expansion",
    optional: false,
    inverse_of: :expandable_expansions
end
