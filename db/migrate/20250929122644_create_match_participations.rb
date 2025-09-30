class CreateMatchParticipations < ActiveRecord::Migration[8.0]
  def change
    create_table :match_participations do |t|
      t.references :match, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :score, null: false, default: 0
      t.integer :correct_count, null: false, default: 0
      t.integer :incorrect_count, null: false, default: 0
      t.integer :best_streak, null: false, default: 0
      t.integer :average_response_ms, null: false, default: 0
      t.datetime :completed_at
      t.string :status, null: false, default: "pending"

      t.timestamps
    end

    add_index :match_participations, [:match_id, :user_id], unique: true
    add_index :match_participations, :status
  end
end
