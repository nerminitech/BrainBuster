class CreateAchievements < ActiveRecord::Migration[8.0]
  def change
    create_table :achievements do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.text :description
      t.integer :points_bonus, null: false, default: 0
      t.integer :threshold, null: false, default: 0
      t.string :category, null: false, default: "general"

      t.timestamps
    end

    add_index :achievements, :code, unique: true
  end
end
