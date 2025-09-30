class CreateQuestionAttempts < ActiveRecord::Migration[8.0]
  def change
    create_table :question_attempts do |t|
      t.references :match_participation, null: false, foreign_key: true
      t.references :match_question, null: false, foreign_key: true
      t.references :answer_option, null: false, foreign_key: true
      t.boolean :correct, null: false, default: false
      t.integer :response_time_ms, null: false, default: 0
      t.integer :awarded_points, null: false, default: 0

      t.timestamps
    end

    add_index :question_attempts, [:match_participation_id, :match_question_id], name: "index_attempts_on_participation_and_question", unique: true
  end
end
