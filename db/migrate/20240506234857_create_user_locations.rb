class CreateUserLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :user_locations, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.references :location, type: :uuid, foreign_key: true
      t.timestamps
      t.datetime :discarded_at, null: true, default: nil
    end

    add_index :user_locations, %i[user_id location_id], unique: true
    add_index :user_locations, %i[created_at updated_at]
    add_index :user_locations, :updated_at
    add_index :user_locations, :discarded_at
  end
end
