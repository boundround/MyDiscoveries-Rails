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

ActiveRecord::Schema.define(version: 20150730205237) do

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
    t.string   "published_status"
    t.float    "view_latitude"
    t.float    "view_longitude"
    t.float    "view_height"
    t.float    "view_heading"
  end

  add_index "areas", ["display_name"], name: "index_areas_on_display_name", using: :btree
  add_index "areas", ["slug"], name: "index_areas_on_slug", using: :btree

  create_table "areas_users", force: true do |t|
    t.integer "user_id", null: false
    t.integer "area_id", null: false
  end

  add_index "areas_users", ["area_id", "user_id"], name: "index_areas_users_on_area_id_and_user_id", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categorizations", force: true do |t|
    t.integer  "category_id"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents", force: true do |t|
    t.text     "description"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["place_id"], name: "index_contents_on_place_id", using: :btree

  create_table "countries", force: true do |t|
    t.string   "display_name"
    t.string   "country_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "capital_city"
    t.string   "capital_city_description"
    t.string   "currency_code"
    t.string   "official_language"
    t.string   "tallest_mountain"
    t.integer  "tallest_mountain_height"
    t.string   "longest_river"
    t.integer  "longest_river_length"
    t.string   "slug"
    t.integer  "area_id"
    t.string   "published_status"
    t.string   "hero_photo"
    t.string   "short_name"
    t.string   "long_name"
    t.string   "photo_credit"
  end

  add_index "countries", ["slug"], name: "index_countries_on_slug", using: :btree

  create_table "countries_famous_faces", force: true do |t|
    t.integer "country_id"
    t.integer "famous_face_id"
  end

  create_table "countries_fun_facts", force: true do |t|
    t.integer "country_id"
    t.integer "fun_fact_id"
  end

  create_table "countries_info_bits", force: true do |t|
    t.integer "country_id"
    t.integer "info_bit_id"
  end

  create_table "countries_photos", force: true do |t|
    t.integer "country_id"
    t.integer "photo_id"
  end

  create_table "countries_videos", force: true do |t|
    t.integer "country_id"
    t.integer "video_id"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "discounts", force: true do |t|
    t.text     "description"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority"
    t.integer  "area_id"
    t.string   "status"
  end

  add_index "discounts", ["place_id"], name: "index_discounts_on_place_id", using: :btree

  create_table "famous_faces", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "photo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_credit"
    t.string   "status"
  end

  create_table "fun_facts", force: true do |t|
    t.text     "content"
    t.string   "reference"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority"
    t.integer  "place_id"
    t.string   "hero_photo"
    t.string   "status"
    t.string   "photo_credit"
  end

  add_index "fun_facts", ["area_id"], name: "index_fun_facts_on_area_id", using: :btree

  create_table "fun_facts_users", force: true do |t|
    t.integer "user_id",     null: false
    t.integer "fun_fact_id", null: false
  end

  add_index "fun_facts_users", ["fun_fact_id", "user_id"], name: "index_fun_facts_users_on_fun_fact_id_and_user_id", unique: true, using: :btree

  create_table "games", force: true do |t|
    t.string   "url"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority"
    t.string   "game_type"
    t.string   "instructions"
    t.integer  "area_id"
    t.string   "thumbnail"
    t.string   "status"
  end

  add_index "games", ["place_id"], name: "index_games_on_place_id", using: :btree

  create_table "games_users", force: true do |t|
    t.integer "user_id", null: false
    t.integer "game_id", null: false
  end

  add_index "games_users", ["game_id", "user_id"], name: "index_games_users_on_game_id_and_user_id", unique: true, using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "info_bits", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "photo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_credit"
    t.string   "status"
  end

  create_table "journal_infos", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
  end

  create_table "photos", force: true do |t|
    t.string   "title"
    t.string   "credit"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "caption"
    t.string   "sound_sprite"
    t.integer  "priority"
    t.integer  "area_id"
    t.integer  "place_id"
    t.string   "caption_source"
    t.string   "alt_tag"
    t.string   "status"
  end

  add_index "photos", ["caption"], name: "index_photos_on_caption", using: :btree

  create_table "photos_users", force: true do |t|
    t.integer "user_id",  null: false
    t.integer "photo_id", null: false
  end

  add_index "photos_users", ["photo_id", "user_id"], name: "index_photos_users_on_photo_id_and_user_id", unique: true, using: :btree

  create_table "places", force: true do |t|
    t.text     "description"
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
    t.text     "opening_hours"
    t.string   "phone_number"
    t.string   "website"
    t.string   "logo"
    t.string   "url"
    t.string   "display_address"
    t.string   "booking_url"
    t.string   "post_code"
    t.string   "street_number"
    t.string   "route"
    t.string   "sublocality"
    t.string   "locality"
    t.string   "country"
    t.string   "state"
    t.string   "place_id"
    t.string   "status"
    t.datetime "published_at"
    t.datetime "unpublished_at"
    t.boolean  "user_created"
    t.string   "created_by"
  end

  add_index "places", ["area_id"], name: "index_places_on_area_id", using: :btree
  add_index "places", ["description"], name: "index_places_on_description", using: :btree
  add_index "places", ["display_name"], name: "index_places_on_display_name", using: :btree
  add_index "places", ["slug"], name: "index_places_on_slug", using: :btree

  create_table "places_users", force: true do |t|
    t.integer "user_id",  null: false
    t.integer "place_id", null: false
  end

  add_index "places_users", ["place_id", "user_id"], name: "index_places_users_on_place_id_and_user_id", unique: true, using: :btree

  create_table "programs", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "yearlevelnotes"
    t.string   "cost"
    t.string   "programpath"
    t.string   "heroimagepath"
    t.string   "duration"
    t.text     "times"
    t.string   "booknowpath"
    t.string   "contact"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "programs", ["place_id"], name: "index_programs_on_place_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "search_queries", force: true do |t|
    t.string   "term"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
  end

  create_table "search_suggestions", force: true do |t|
    t.string   "term"
    t.integer  "popularity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suggested_places", force: true do |t|
    t.string   "user_ip"
    t.string   "place"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_photos", force: true do |t|
    t.string   "title"
    t.string   "credit"
    t.string   "path"
    t.string   "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "user_photos", ["user_id"], name: "index_user_photos_on_user_id", using: :btree

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
    t.string   "avatar"
    t.string   "country"
    t.date     "date_of_birth"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "promo_code"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "version_associations", force: true do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  create_table "videos", force: true do |t|
    t.integer  "vimeo_id"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
    t.integer  "priority"
    t.string   "vimeo_thumbnail"
    t.string   "status"
  end

  add_index "videos", ["area_id"], name: "index_videos_on_area_id", using: :btree
  add_index "videos", ["place_id"], name: "index_videos_on_place_id", using: :btree

  create_table "videos_users", force: true do |t|
    t.integer "user_id"
    t.integer "video_id"
  end

  add_index "videos_users", ["video_id", "user_id"], name: "index_videos_users_on_video_id_and_user_id", unique: true, using: :btree

  create_table "webresources", force: true do |t|
    t.string   "caption"
    t.string   "path"
    t.integer  "program_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "webresources", ["program_id"], name: "index_webresources_on_program_id", using: :btree

end
