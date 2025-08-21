class ChangeConditionTypeOnCopies < ActiveRecord::Migration[8.0]
  def up
    rename_column :copies,
      :condition,
      :condition_varchar

    add_column :copies,
      :condition,
      "ENUM('unknown','new','excellent','good','fair','poor')",
      null: false,
      default: "unknown",
      after: :location_id

    execute <<-SQL
      UPDATE `copies`
      SET `condition` = (
        CASE
          WHEN `condition_varchar` = 'new' THEN 'new'
          WHEN `condition_varchar` = 'excellent' THEN 'excellent'
          WHEN `condition_varchar` = 'good' THEN 'good'
          WHEN `condition_varchar` = 'fair' THEN 'fair'
          WHEN `condition_varchar` = 'poor' THEN 'poor'
          ELSE 'unknown'
        END
      )
    SQL

    remove_column :copies,
      :condition_varchar
  end

  def down
    rename_column :copies,
      :condition,
      :condition_enum

    add_column :copies,
      :condition,
      :string,
      null: true,
      default: nil,
      after: :location_id

    execute <<-SQL
      UPDATE `copies`
      SET `condition` = (
        CASE
          WHEN `condition_enum` = 'new' THEN 'new'
          WHEN `condition_enum` = 'excellent' THEN 'excellent'
          WHEN `condition_enum` = 'good' THEN 'good'
          WHEN `condition_enum` = 'fair' THEN 'fair'
          WHEN `condition_enum` = 'poor' THEN 'poor'
          ELSE 'unknown'
        END
      )
    SQL
  end
end
