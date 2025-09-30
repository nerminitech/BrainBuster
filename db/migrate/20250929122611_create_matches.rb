class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :category, null: false, foreign_key: true
      t.string :mode, null: false, default: "solo"
      t.string :state, null: false, default: "draft"
      t.integer :question_count, null: false, default: 10
      t.integer :time_per_question, null: false, default: 30
      t.string :share_code, null: false
      t.datetime :started_at
      t.datetime :completed_at
      t.string :title

      t.timestamps
    end

    add_index :matches, :share_code, unique: true
    add_index :matches, :mode
    add_index :matches, :state
  end
end
