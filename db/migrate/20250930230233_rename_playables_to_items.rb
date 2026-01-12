class RenamePlayablesToItems < ActiveRecord::Migration[8.0]
  def change
    rename_table :playables, :items

    add_column :items, :playable_id, :uuid,
      null: true,
      default: nil,
      after: :id
    add_column :items, :playable_type, :string,
      null: true,
      default: nil,
      after: :playable_id

    add_index :items, %i[playable_type playable_id],
      unique: true
  end
end
