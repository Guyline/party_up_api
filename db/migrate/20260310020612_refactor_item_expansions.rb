class RefactorItemExpansions < ActiveRecord::Migration[8.1]
  def change
    remove_index :item_expansions, %i[created_at updated_at]
    remove_index :item_expansions, :updated_at
    drop_table :item_expansions do |t|
      t.references :item,
        foreign_key: {
          to_table: :items
        },
        null: true,
        default: nil
      t.references :expansion,
        foreign_key: {
          to_table: :expansions
        },
        null: true,
        default: nil
      t.timestamps
    end

    create_table :item_expansions do |t|
      t.references :expandable_item,
        index: false,
        foreign_key: {
          to_table: :items
        },
        null: false
      t.references :expansion_item,
        foreign_key: {
          to_table: :items
        },
        null: false
      t.timestamps
    end
    add_index :item_expansions,
      [
        :expandable_item_id,
        :expansion_item_id
      ],
      unique: true
    add_foreign_key :item_expansions,
      :items,
      column: :expandable_item_id,
      if_not_exists: true
  end
end
