class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations, id: :uuid do |t|
      t.string :type, null: true, default: nil
      t.string :number, null: true, default: nil
      t.string :street, null: true, default: nil
      t.string :city, null: true, default: nil
      t.string :state, null: true, default: nil
      t.string :postal_code, null: true, default: nil
      t.string :country, null: true, default: nil
      t.string :google_place_id, null: true, default: nil
      t.timestamps
    end
    add_index :locations, :google_place_id
  end
end
