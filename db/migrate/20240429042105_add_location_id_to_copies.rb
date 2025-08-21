class AddLocationIdToCopies < ActiveRecord::Migration[7.1]
  def change
    add_column :copies,
      :location_id,
      :uuid,
      null: true,
      default: nil,
      after: :version_id
    add_foreign_key :copies, :locations
  end
end
