class CreateIdentities < ActiveRecord::Migration[7.1]
  def change
    create_table :identities, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.string :provider, index: true
      t.string :uid
      t.string :email, index: true
      t.timestamps

      t.index %i[uid provider], unique: true
    end
  end
end
