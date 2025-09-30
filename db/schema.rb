# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_30_081825) do
  create_table "achievements", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "points_bonus", default: 0, null: false
    t.integer "threshold", default: 0, null: false
    t.string "category", default: "general", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_achievements_on_code", unique: true
  end

  create_table "answer_options", force: :cascade do |t|
    t.integer "question_id", null: false
    t.string "text", null: false
    t.boolean "correct", default: false, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id", "position"], name: "index_answer_options_on_question_id_and_position", unique: true
    t.index ["question_id"], name: "index_answer_options_on_question_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "featured", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "match_participations", force: :cascade do |t|
    t.integer "match_id", null: false
    t.integer "user_id", null: false
    t.integer "score", default: 0, null: false
    t.integer "correct_count", default: 0, null: false
    t.integer "incorrect_count", default: 0, null: false
    t.integer "best_streak", default: 0, null: false
    t.integer "average_response_ms", default: 0, null: false
    t.datetime "completed_at"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_match_question_id"
    t.datetime "current_question_started_at"
    t.index ["current_match_question_id"], name: "index_match_participations_on_current_match_question_id"
    t.index ["match_id", "user_id"], name: "index_match_participations_on_match_id_and_user_id", unique: true
    t.index ["match_id"], name: "index_match_participations_on_match_id"
    t.index ["status"], name: "index_match_participations_on_status"
    t.index ["user_id"], name: "index_match_participations_on_user_id"
  end

  create_table "match_questions", force: :cascade do |t|
    t.integer "match_id", null: false
    t.integer "question_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id", "position"], name: "index_match_questions_on_match_id_and_position", unique: true
    t.index ["match_id"], name: "index_match_questions_on_match_id"
    t.index ["question_id"], name: "index_match_questions_on_question_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "creator_id", null: false
    t.integer "category_id", null: false
    t.string "mode", default: "solo", null: false
    t.string "state", default: "draft", null: false
    t.integer "question_count", default: 10, null: false
    t.integer "time_per_question", default: 30, null: false
    t.string "share_code", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_matches_on_category_id"
    t.index ["creator_id"], name: "index_matches_on_creator_id"
    t.index ["mode"], name: "index_matches_on_mode"
    t.index ["share_code"], name: "index_matches_on_share_code", unique: true
    t.index ["state"], name: "index_matches_on_state"
  end

  create_table "question_attempts", force: :cascade do |t|
    t.integer "match_participation_id", null: false
    t.integer "match_question_id", null: false
    t.integer "answer_option_id"
    t.boolean "correct", default: false, null: false
    t.integer "response_time_ms", default: 0, null: false
    t.integer "awarded_points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_option_id"], name: "index_question_attempts_on_answer_option_id"
    t.index ["match_participation_id", "match_question_id"], name: "index_attempts_on_participation_and_question", unique: true
    t.index ["match_participation_id"], name: "index_question_attempts_on_match_participation_id"
    t.index ["match_question_id"], name: "index_question_attempts_on_match_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "category_id", null: false
    t.text "content", null: false
    t.text "explanation"
    t.string "difficulty", default: "mittel", null: false
    t.integer "time_limit_seconds", default: 30, null: false
    t.integer "base_points", default: 100, null: false
    t.string "source_url"
    t.string "language", default: "de", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_questions_on_category_id"
    t.index ["difficulty"], name: "index_questions_on_difficulty"
  end

  create_table "user_achievements", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "achievement_id", null: false
    t.datetime "awarded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_id"], name: "index_user_achievements_on_achievement_id"
    t.index ["user_id", "achievement_id"], name: "index_user_achievements_on_user_id_and_achievement_id", unique: true
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "display_name"
    t.integer "role", default: 0, null: false
    t.integer "total_points", default: 0, null: false
    t.integer "daily_streak", default: 0, null: false
    t.integer "achievements_count", default: 0, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "answer_options", "questions"
  add_foreign_key "match_participations", "match_questions", column: "current_match_question_id"
  add_foreign_key "match_participations", "matches"
  add_foreign_key "match_participations", "users"
  add_foreign_key "match_questions", "matches"
  add_foreign_key "match_questions", "questions"
  add_foreign_key "matches", "categories"
  add_foreign_key "matches", "users", column: "creator_id"
  add_foreign_key "question_attempts", "answer_options"
  add_foreign_key "question_attempts", "match_participations"
  add_foreign_key "question_attempts", "match_questions"
  add_foreign_key "questions", "categories"
  add_foreign_key "user_achievements", "achievements"
  add_foreign_key "user_achievements", "users"
end
