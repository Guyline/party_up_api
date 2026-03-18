class RemoveDelegatedTypeFromItems < ActiveRecord::Migration[8.1]
  def change
    remove_index :items, %i[playable_type playable_id],
      unique: true

    remove_column :items, :playable_type, :string,
      null: true,
      default: nil,
      after: :playable_id
    remove_column :items, :playable_id, :uuid,
      null: true,
      default: nil,
      after: :id

    add_column :items, :type, :string,
      null: true,
      default: nil,
      after: :public_id
  end
end
