# frozen_string_literal: true

class ChangeLocationIdToReferenceOnCopies < ActiveRecord::Migration[8.0]
  def change
    # remove_foreign_key :copies, :locations
    remove_column :copies,
      :location_id,
      :uuid,
      null: true,
      default: nil,
      after: :version_id
    add_reference :copies,
      :location,
      type: :uuid,
      null: true,
      default: nil,
      after: :version_id
  end
end
