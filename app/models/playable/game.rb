class Playable::Game < Playable
  has_many :playable_expansions, inverse_of: :playable
  has_many :expansions, through: :playable_expansions, source: :expansion
end
