class ItemExpansion < ApplicationRecord
  belongs_to :item,
    optional: false
  belongs_to :expansion,
    class_name: Expansion.name.to_s,
    optional: false,
    inverse_of: :expandable_expansions
end
