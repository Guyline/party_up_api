class CreateVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :versions, id: :uuid do |t|
      t.references :game, type: :uuid, null: false, foreign_key: true
      t.integer :bgg_id, null: true, default: nil, index: { unique: true }
      t.string :name, null: true, default: nil
      t.integer :publication_year, limit: 2 # SMALLINT
      t.timestamps
    end
    add_index :versions, :name
    add_index :versions, %i[created_at updated_at]
    add_index :versions, :updated_at
  end
end
