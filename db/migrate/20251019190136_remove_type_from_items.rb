# frozen_string_literal: true

class RemoveTypeFromItems < ActiveRecord::Migration[8.0]
  def change
    remove_column :items,
      :type,
      :string,
      null: true,
      default: nil,
      after: :playable_type
  end
end
