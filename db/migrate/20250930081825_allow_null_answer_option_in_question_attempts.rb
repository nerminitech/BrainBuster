class AllowNullAnswerOptionInQuestionAttempts < ActiveRecord::Migration[8.0]
  def change
    change_column_null :question_attempts, :answer_option_id, true
  end
end
