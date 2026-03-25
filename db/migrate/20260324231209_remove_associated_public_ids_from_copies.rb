class RemoveAssociatedPublicIdsFromCopies < ActiveRecord::Migration[8.1]
  def change
    remove_column :copies,
      :holder_public_id,
      :string,
      after: :holder_id,
      null: true,
      default: nil
    remove_column :copies,
      :item_public_id,
      :string,
      after: :item_id,
      null: true,
      default: nil
    remove_column :copies,
      :version_public_id,
      :string,
      after: :version_id,
      null: true,
      default: nil
    remove_column :copies,
      :location_public_id,
      :string,
      after: :location_id,
      null: true,
      default: nil
  end
end
