class Playable::Expansion < Playable
  has_many :playable_expansions_as_playable,
           class_name: 'PlayableExpansion',
           inverse_of: :playable
  has_many :expansions,
           through: :playable_expansions_as_playable,
           source: :expansion

  has_many :playable_expansions_as_expansion,
           class_name: 'PlayableExpansion',
           inverse_of: :expansion

  has_many :expandables,
           through: :playable_expansions_as_expansion,
           source: :playable
  has_many :expandable_games,
           through: :playable_expansions_as_expansion,
           source: :playable,
           class_name: 'Playable::Game'
  has_many :expandable_expansions,
           through: :playable_expansions_as_expansion,
           source: :playable,
           class_name: 'Playable::Expansion'
end
