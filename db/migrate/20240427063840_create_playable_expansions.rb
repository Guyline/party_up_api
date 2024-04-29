class CreatePlayableExpansions < ActiveRecord::Migration[7.1]
  def change
    create_table :playable_expansions do |t|
      t.references :playable,
                   type: :uuid,
                   foreign_key: {
                     to_table: :playables
                   },
                   null: true,
                   default: nil
      t.references :expansion,
                   type: :uuid,
                   foreign_key: {
                     to_table: :playables
                   },
                   null: true,
                   default: nil
      t.timestamps
    end
    add_index :playable_expansions, %i[created_at updated_at]
    add_index :playable_expansions, :updated_at
  end
end
