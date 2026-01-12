# frozen_string_literal: true

class CreateExpansions < ActiveRecord::Migration[8.0]
  def change
    create_table :expansions, id: :uuid, &:timestamps

    add_index :expansions, %i[created_at updated_at]
    add_index :expansions, :updated_at
  end
end
