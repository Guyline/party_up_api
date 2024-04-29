class RenameGamesToPlayables < ActiveRecord::Migration[7.1]
  def change
    rename_table :games, :playables
    add_column :playables, :type, :string, null: true, default: nil, after: :id

    rename_column :versions, :game_id, :playable_id
    rename_column :copies, :game_id, :playable_id
  end
end
