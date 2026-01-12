# frozen_string_literal: true

class RenamePlayableIdToItemIdOnVersions < ActiveRecord::Migration[8.0]
  def change
    rename_column :versions, :playable_id, :item_id
  end
end
