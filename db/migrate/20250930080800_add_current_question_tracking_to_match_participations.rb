class AddCurrentQuestionTrackingToMatchParticipations < ActiveRecord::Migration[8.0]
  def change
    add_reference :match_participations, :current_match_question, null: false, foreign_key: true
    add_column :match_participations, :current_question_started_at, :datetime
  end
end
