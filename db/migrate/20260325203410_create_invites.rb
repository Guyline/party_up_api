class CreateInvites < ActiveRecord::Migration[8.1]
  def change
    create_table :invites do |t|
      t.string :public_id,
        default: nil,
        null: true
      t.references :meetup,
        foreign_key: {
          to_table: :meetups
        },
        index: false,
        null: false
      t.references :invitee,
        foreign_key: {
          to_table: :users
        },
        null: false
      t.references :inviter,
        foreign_key: {
          to_table: :users
        },
        null: true
      t.boolean :is_host,
        default: false
      t.datetime :accepted_at,
        default: nil
      t.datetime :rejected_at,
        default: nil
      t.timestamps

      t.index :public_id,
        unique: true
      t.index [
        :meetup_id,
        :invitee_id
      ],
        unique: true
    end
  end
end
