# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140625160149) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: true do |t|
    t.string   "code"
    t.string   "identifier"
    t.string   "country"
    t.string   "display_name"
    t.string   "short_intro"
    t.text     "description"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "slug"
  end

  add_index "areas", ["slug"], name: "index_areas_on_slug", using: :btree

  create_table "photos", force: true do |t|
    t.string   "title"
    t.string   "credit"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "fun_fact"
    t.string   "sound_sprite"
    t.integer  "photoable_id"
    t.string   "photoable_type"
  end

  create_table "places", force: true do |t|
    t.string   "description"
    t.string   "code"
    t.string   "identifier"
    t.string   "display_name"
    t.string   "subscription_level"
    t.string   "icon"
    t.string   "map_icon"
    t.string   "passport_icon"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
  end

  add_index "places", ["area_id"], name: "index_places_on_area_id", using: :btree
  add_index "places", ["slug"], name: "index_places_on_slug", using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: true do |t|
    t.integer  "vimeo_id"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "videos", ["area_id"], name: "index_videos_on_area_id", using: :btree

end
