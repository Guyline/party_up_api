class ChangeUsersUsernameToNullable < ActiveRecord::Migration[7.1]
  def up
    change_table :users do |t|
      t.change :username, :string, null: true, default: nil
    end
  end

  def down
    # Cannot make field nullable again after NULL values already present...
  end
end
