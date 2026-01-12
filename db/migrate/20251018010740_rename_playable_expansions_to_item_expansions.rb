# frozen_string_literal: true

class RenamePlayableExpansionsToItemExpansions < ActiveRecord::Migration[8.0]
  def change
    rename_table :playable_expansions, :item_expansions
    rename_column :item_expansions, :playable_id, :item_id
    remove_reference :item_expansions, :expansion,
      type: :uuid,
      foreign_key: {
        to_table: :items
      },
      null: true,
      default: nil
    add_reference :item_expansions,
      :expansion,
      type: :uuid,
      foreign_key: {
        to_table: :expansions
      },
      after: :item_id,
      null: true,
      default: nil
  end
end
