class ItemExpansion < ApplicationRecord
  belongs_to :expandable_item,
    class_name: "Item",
    optional: false,
    inverse_of: :item_expansions_as_expandable
  belongs_to :expansion_item,
    class_name: "Expansion",
    optional: false,
    inverse_of: :item_expansions_as_expansion
end
