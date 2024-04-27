class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games, id: :uuid do |t|
      t.integer :bgg_id, null: true, default: nil, index: { unique: true }
      t.string :name, null: true, default: nil
      t.string :bgg_image_url, null: true, default: nil
      t.string :bgg_thumbnail_url, null: true, default: nil
      t.timestamps
    end
    add_index :games, :name
    add_index :games, %i[created_at updated_at]
    add_index :games, :updated_at
  end
end
