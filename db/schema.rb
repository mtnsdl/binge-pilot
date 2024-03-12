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

ActiveRecord::Schema[7.1].define(version: 2024_03_08_145441) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.string "status_like"
    t.string "status_watch"
    t.bigint "user_id", null: false
    t.bigint "content_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "offered", default: false
    t.index ["content_id"], name: "index_bookmarks_on_content_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.string "picture_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "content_identifier"
    t.string "medium"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.bigint "mood_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "genre_identifier"
    t.string "genre_format"
    t.index ["mood_id"], name: "index_genres_on_mood_id"
  end

  create_table "moods", force: :cascade do |t|
    t.string "name"
    t.string "icon_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string "streaming_platform"
    t.string "streaming_url"
    t.string "streaming_icon"
    t.bigint "contents_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contents_id"], name: "index_providers_on_contents_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookmarks", "contents"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "genres", "moods"
  add_foreign_key "providers", "contents", column: "contents_id"
end
