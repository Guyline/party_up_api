class CreateMeetups < ActiveRecord::Migration[8.1]
  def change
    create_table :meetups do |t|
      t.string :public_id,
        default: nil,
        null: true
      t.references :creator,
        default: nil,
        foreign_key: {
          to_table: :users
        },
        null: true
      t.references :location,
        default: nil,
        foreign_key: {
          to_table: :locations
        },
        null: true
      t.text :description,
        default: nil,
        null: true
      t.boolean :is_public,
        default: false
      t.column :exclusivity,
        "ENUM('creator_invite','host_invite','attendee_invite','open')",
        default: "creator_invite"
      t.datetime :starts_at,
        default: nil,
        null: true
      t.datetime :ends_at,
        default: nil,
        null: true
      t.datetime :published_at,
        default: nil,
        null: true
      t.datetime :canceled_at,
        default: nil,
        null: true
      t.integer :invites_count,
        default: 0,
        null: false,
        unsigned: true
      t.integer :attendees_count,
        default: 0,
        null: false,
        unsigned: true
      t.timestamps

      t.index :public_id,
        unique: true
    end
  end
end
