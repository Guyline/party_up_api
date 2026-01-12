# frozen_string_literal: true

class RenamePlayableIdToItemIdOnCopies < ActiveRecord::Migration[8.0]
  def change
    rename_column :copies, :playable_id, :item_id
  end
end
