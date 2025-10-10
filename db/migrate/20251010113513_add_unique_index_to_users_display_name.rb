class AddUniqueIndexToUsersDisplayName < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL
      UPDATE users
      SET display_name = NULL
      WHERE id IN (
        SELECT id FROM (
          SELECT id,
                 row_number() OVER (PARTITION BY lower(display_name) ORDER BY id) AS rn
          FROM users
          WHERE display_name IS NOT NULL
        ) AS duplicates
        WHERE duplicates.rn > 1
      )
    SQL

    add_index :users, "lower(display_name)", unique: true, name: "index_users_on_lower_display_name", where: "display_name IS NOT NULL"
  end

  def down
    remove_index :users, name: "index_users_on_lower_display_name"
  end
end
