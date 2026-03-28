class CreatePlays < ActiveRecord::Migration[8.1]
  def change
    create_table :plays do |t|
      t.string :public_id,
        default: nil,
        null: true
      t.references :meetup,
        foreign_key: {
          to_table: :meetups
        },
        index: false,
        null: false
      t.references :item,
        foreign_key: {
          to_table: :items
        },
        null: false
      t.references :copy,
        default: nil,
        foreign_key: {
          to_table: :copies
        },
        null: true
      t.references :proposer,
        foreign_key: {
          to_table: :users
        },
        null: false
      t.references :holder,
        default: nil,
        foreign_key: {
          to_table: :users
        },
        null: true
      t.references :primary_instructor,
        default: nil,
        foreign_key: {
          to_table: :users
        },
        null: true
      t.integer :familiarity,
        default: nil,
        null: true,
        unsigned: true
      t.integer :priority,
        default: nil,
        null: true,
        unsigned: true
      t.text :proposer_notes,
        default: nil,
        null: true
      t.boolean :was_played,
        default: nil,
        null: true
      t.timestamps

      t.index :public_id,
        unique: true
      t.index [
        :meetup_id,
        :item_id
      ],
        unique: true
    end
  end
end
