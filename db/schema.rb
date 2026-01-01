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

ActiveRecord::Schema[8.1].define(version: 2026_01_01_170209) do
  create_table "event_topics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "key"
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_event_topics_on_key", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "event_topic_id", null: false
    t.datetime "expires_at"
    t.integer "inviter_id", null: false
    t.datetime "updated_at", null: false
    t.index ["event_topic_id"], name: "index_events_on_event_topic_id"
    t.index ["expires_at"], name: "index_events_on_expires_at"
    t.index ["inviter_id"], name: "index_events_on_inviter_id"
  end

  create_table "friend_invites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.integer "inviter_id", null: false
    t.string "token", null: false
    t.index ["expires_at"], name: "index_friend_invites_on_expires_at"
    t.index ["inviter_id"], name: "index_friend_invites_on_inviter_id"
    t.index ["token"], name: "index_friend_invites_on_token", unique: true
  end

  create_table "friendships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "friend_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true
    t.index ["user_id"], name: "index_friendships_on_user_id"
    t.check_constraint "user_id != friend_id", name: "friendships_no_self_friends"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.integer "friends_count", default: 0, null: false
    t.string "google_sub", null: false
    t.string "name"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["google_sub"], name: "index_users_on_google_sub", unique: true
  end

  add_foreign_key "events", "event_topics"
  add_foreign_key "events", "users", column: "inviter_id"
  add_foreign_key "friend_invites", "users", column: "inviter_id"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "sessions", "users"
end
