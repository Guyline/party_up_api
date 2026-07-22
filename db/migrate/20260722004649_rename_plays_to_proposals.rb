class RenamePlaysToProposals < ActiveRecord::Migration[8.1]
  def change
    rename_table :plays, :proposals
    remove_column :proposals,
      :was_played,
      type: :boolean,
      default: nil,
      null: true
  end
end
