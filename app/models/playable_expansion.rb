class PlayableExpansion < ApplicationRecord
  belongs_to :playable,
             required: true
  belongs_to :expansion,
             class_name: 'Playable::Expansion',
             required: true,
             inverse_of: :expandable_expansions
end
