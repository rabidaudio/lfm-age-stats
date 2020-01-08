# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_08_024433) do

  create_table "scrobbles", force: :cascade do |t|
    t.string "track"
    t.string "artist"
    t.string "album"
    t.string "track_mbid"
    t.string "artist_mbid"
    t.string "album_mbid"
    t.string "username"
    t.datetime "scrobbled_at"
    t.date "release_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["release_date"], name: "index_scrobbles_on_release_date"
    t.index ["scrobbled_at"], name: "index_scrobbles_on_scrobbled_at"
    t.index ["username"], name: "index_scrobbles_on_username"
  end

end
