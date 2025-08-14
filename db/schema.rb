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

ActiveRecord::Schema[8.0].define(version: 2025_08_14_133925) do
  create_table "games", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.string "position", null: false
    t.text "truth_1", null: false
    t.text "truth_2", null: false
    t.text "lie", null: false
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_games_on_active"
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "position"
    t.string "email"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "voter_id", null: false
    t.string "selected_statement", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "voter_id"], name: "index_votes_on_game_id_and_voter_id", unique: true
    t.index ["game_id"], name: "index_votes_on_game_id"
    t.index ["voter_id"], name: "index_votes_on_voter_id"
  end

  add_foreign_key "games", "users"
  add_foreign_key "votes", "games"
  add_foreign_key "votes", "users", column: "voter_id"
end
