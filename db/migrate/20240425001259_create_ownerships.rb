class CreateOwnerships < ActiveRecord::Migration[7.1]
  def change
    create_table :ownerships, id: :uuid do |t|
      t.references :copy, type: :uuid, foreign_key: true, null: true, default: nil
      t.references :owner, type: :uuid, foreign_key: { to_table: :users }, null: true, default: nil
      t.timestamps
      t.datetime :discarded_at, null: true, default: nil
    end
    add_index :ownerships, %i[copy_id owner_id], unique: true
    add_index :ownerships, %i[created_at updated_at]
    add_index :ownerships, :updated_at
    add_index :ownerships, :discarded_at
  end
end
