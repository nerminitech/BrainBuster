class AddConditionToAchievements < ActiveRecord::Migration[8.0]
  def change
    add_column :achievements, :condition, :string, null: false, default: "manual"
  end
end
