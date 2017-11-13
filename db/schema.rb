# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171112213224) do

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "microposts", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_microposts_on_user_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "title"
    t.string "caption"
    t.text "description"
    t.string "file"
    t.integer "waypoint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title", "waypoint_id"], name: "index_pictures_on_title_and_waypoint_id", unique: true
    t.index ["waypoint_id"], name: "index_pictures_on_waypoint_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "rides", force: :cascade do |t|
    t.integer "user_id"
    t.integer "trail_id"
    t.datetime "start"
    t.datetime "end"
    t.string "gpx_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trail_id"], name: "index_rides_on_trail_id"
    t.index ["user_id"], name: "index_rides_on_user_id"
  end

  create_table "trails", force: :cascade do |t|
    t.string "name"
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_trails_on_location_id"
    t.index ["name", "location_id"], name: "index_trails_on_name_and_location_id", unique: true
    t.index ["name"], name: "index_trails_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "waypoints", force: :cascade do |t|
    t.float "lat"
    t.float "lon"
    t.text "description"
    t.integer "ride_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lat", "lon", "ride_id"], name: "index_waypoints_on_lat_and_lon_and_ride_id", unique: true
    t.index ["ride_id"], name: "index_waypoints_on_ride_id"
  end

end
