class CreateCopies < ActiveRecord::Migration[7.1]
  def change
    create_table :copies, id: :uuid do |t|
      t.references :holder, type: :uuid, foreign_key: { to_table: :users }, null: true, default: nil
      t.references :game, type: :uuid, foreign_key: true
      t.references :version, type: :uuid, foreign_key: true, null: true, default: nil
      t.string :condition, null: true, default: nil
      t.boolean :is_playable, default: false
      t.boolean :is_borrowable, default: false
      t.boolean :is_tradeable, default: false
      t.boolean :is_purchaseable, default: false
      t.decimal :asking_price, null: true, default: nil, precision: 7, scale: 2
      t.string :asking_currency, null: true, default: nil, limit: 3
      t.timestamps
    end

    add_index :copies, %i[game_id holder_id version_id]
    add_index :copies, %i[game_id version_id]
    add_index :copies, %i[holder_id version_id]
    add_index :copies, %i[created_at updated_at]
    add_index :copies, :updated_at
  end
end
