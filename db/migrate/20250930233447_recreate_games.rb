# frozen_string_literal: true

class RecreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games, id: :uuid, &:timestamps

    add_index :games, %i[created_at updated_at]
    add_index :games, :updated_at
  end
end
