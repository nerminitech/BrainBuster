class CreateMatchQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :match_questions do |t|
      t.references :match, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :match_questions, [:match_id, :position], unique: true
  end
end
