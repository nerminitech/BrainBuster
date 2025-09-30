class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.references :category, null: false, foreign_key: true
      t.text :content, null: false
      t.text :explanation
      t.string :difficulty, null: false, default: "mittel"
      t.integer :time_limit_seconds, null: false, default: 30
      t.integer :base_points, null: false, default: 100
      t.string :source_url
      t.string :language, null: false, default: "de"

      t.timestamps
    end

    add_index :questions, :difficulty
  end
end
