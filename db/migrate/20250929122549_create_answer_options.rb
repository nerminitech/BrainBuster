class CreateAnswerOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :answer_options do |t|
      t.references :question, null: false, foreign_key: true
      t.string :text, null: false
      t.boolean :correct, null: false, default: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :answer_options, [ :question_id, :position ], unique: true
  end
end
