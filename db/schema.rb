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

ActiveRecord::Schema.define(version: 20161222040625) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

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
    t.integer  "country_id"
    t.string   "google_place_id"
  end

  add_index "areas", ["country_id"], name: "index_areas_on_country_id", using: :btree
  add_index "areas", ["display_name"], name: "index_areas_on_display_name", using: :btree
  add_index "areas", ["slug"], name: "index_areas_on_slug", using: :btree

  create_table "areas_users", force: true do |t|
    t.integer "user_id", null: false
    t.integer "area_id", null: false
  end

  add_index "areas_users", ["area_id", "user_id"], name: "index_areas_users_on_area_id_and_user_id", unique: true, using: :btree

  create_table "attractions", force: true do |t|
    t.text     "description"
    t.string   "code"
    t.string   "identifier"
    t.string   "display_name"
    t.string   "subscription_level"
    t.string   "icon"
    t.string   "map_icon"
    t.string   "passport_icon"
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
    t.string   "state"
    t.string   "place_id"
    t.string   "status"
    t.datetime "published_at"
    t.datetime "unpublished_at"
    t.boolean  "user_created"
    t.string   "created_by"
    t.boolean  "customer_review"
    t.boolean  "customer_approved"
    t.datetime "approved_at"
    t.boolean  "show_on_school_safari",     default: false
    t.text     "school_safari_description"
    t.string   "hero_image"
    t.string   "bound_round_place_id"
    t.boolean  "is_area",                   default: false
    t.text     "meta_description"
    t.string   "weather_conditions"
    t.integer  "minimum_age"
    t.integer  "maximum_age"
    t.text     "special_requirements"
    t.boolean  "top_100",                   default: false
    t.text     "viator_link",               default: ""
    t.boolean  "footer_include"
    t.boolean  "primary_area"
    t.string   "algolia_id"
    t.string   "email"
    t.integer  "parent_id"
    t.string   "trip_advisor_url"
    t.decimal  "page_ranking_weight"
    t.integer  "algolia_clicks",            default: 0
    t.integer  "area_id"
    t.integer  "country_id"
    t.integer  "user_id"
    t.integer  "primary_category_id"
    t.text     "focus_keyword"
    t.text     "seo_title"
  end

  add_index "attractions", ["country_id"], name: "index_attractions_on_country_id", using: :btree
  add_index "attractions", ["primary_category_id"], name: "index_attractions_on_primary_category_id", using: :btree
  add_index "attractions", ["user_id"], name: "index_attractions_on_user_id", using: :btree

  create_table "attractions_posts", force: true do |t|
    t.integer "attraction_id"
    t.integer "post_id"
  end

  create_table "attractions_stories", force: true do |t|
    t.integer  "attraction_id"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attractions_subcategories", force: true do |t|
    t.integer "attraction_id"
    t.integer "subcategory_id"
    t.text    "desc"
  end

  create_table "attractions_users", force: true do |t|
    t.integer "user_id"
    t.integer "attraction_id"
  end

  create_table "average_caches", force: true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "avg",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_image_galleries", force: true do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: true do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bug_posts", force: true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.string   "screen_shot"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "child_items", force: true do |t|
    t.string   "itemable_type"
    t.integer  "itemable_id"
    t.string   "parentable_type"
    t.integer  "parentable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "child_items", ["itemable_id"], name: "index_child_items_on_itemable_id", using: :btree
  add_index "child_items", ["itemable_type"], name: "index_child_items_on_itemable_type", using: :btree
  add_index "child_items", ["parentable_id"], name: "index_child_items_on_parentable_id", using: :btree
  add_index "child_items", ["parentable_type"], name: "index_child_items_on_parentable_type", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "competitions", force: true do |t|
    t.text     "url"
    t.text     "title"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.date     "start_date"
    t.date     "end_date"
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
    t.string   "published_status"
    t.string   "hero_photo"
    t.string   "short_name"
    t.string   "long_name"
    t.string   "photo_credit"
    t.string   "google_place_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.decimal  "page_ranking_weight"
    t.integer  "algolia_clicks",           default: 0
    t.text     "focus_keyword"
    t.text     "seo_title"
    t.text     "meta_description"
  end

  add_index "countries", ["slug"], name: "index_countries_on_slug", using: :btree

  create_table "countries_discounts", force: true do |t|
    t.integer  "country_id"
    t.integer  "discount_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "countries_posts", id: false, force: true do |t|
    t.integer "country_id", null: false
    t.integer "post_id",    null: false
  end

  add_index "countries_posts", ["country_id", "post_id"], name: "index_countries_posts_on_country_id_and_post_id", using: :btree
  add_index "countries_posts", ["post_id", "country_id"], name: "index_countries_posts_on_post_id_and_country_id", using: :btree

  create_table "countries_stories", force: true do |t|
    t.integer  "country_id"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries_stories", ["country_id", "story_id"], name: "index_countries_stories_on_country_id_and_story_id", unique: true, using: :btree

  create_table "countries_users", force: true do |t|
    t.integer "user_id"
    t.integer "country_id"
  end

  create_table "countries_videos", force: true do |t|
    t.integer "country_id"
    t.integer "video_id"
  end

  create_table "custom_reports", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers_attractions", force: true do |t|
    t.integer "user_id"
    t.integer "attraction_id"
  end

  create_table "customers_places", force: true do |t|
    t.integer "user_id"
    t.integer "place_id"
  end

  create_table "deals", force: true do |t|
    t.string   "url"
    t.string   "hero_image"
    t.string   "description"
    t.integer  "min_price"
    t.integer  "dealable_id"
    t.string   "dealable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "status"
  end

  add_index "deals", ["dealable_id", "dealable_type"], name: "index_deals_on_dealable_id_and_dealable_type", using: :btree

  create_table "deals_users", force: true do |t|
    t.integer "user_id"
    t.integer "deal_id"
  end

  create_table "discounts", force: true do |t|
    t.text     "description"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority"
    t.integer  "area_id"
    t.string   "status"
    t.boolean  "country_include"
    t.boolean  "customer_review"
    t.boolean  "customer_approved"
    t.datetime "approved_at"
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

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

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
    t.boolean  "country_include"
    t.boolean  "customer_review"
    t.boolean  "customer_approved"
    t.datetime "approved_at"
    t.integer  "attraction_id"
    t.integer  "fun_factable_id"
    t.string   "fun_factable_type"
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
    t.boolean  "customer_review"
    t.boolean  "customer_approved"
    t.datetime "approved_at"
  end

  add_index "games", ["place_id"], name: "index_games_on_place_id", using: :btree

  create_table "games_users", force: true do |t|
    t.integer "user_id", null: false
    t.integer "game_id", null: false
  end

  add_index "games_users", ["game_id", "user_id"], name: "index_games_users_on_game_id_and_user_id", unique: true, using: :btree

  create_table "good_to_knows", force: true do |t|
    t.text     "description",                          null: false
    t.boolean  "show_on_page",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "good_to_knowable_id"
    t.string   "good_to_knowable_type"
  end

  add_index "good_to_knows", ["good_to_knowable_id", "good_to_knowable_type"], name: "good_to_knowable_index", using: :btree

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

  create_table "offers", force: true do |t|
    t.integer  "attraction_id"
    t.string   "status",                                                 default: ""
    t.text     "name",                                                   default: ""
    t.text     "description",                                            default: ""
    t.integer  "minRateAdult",                                           default: 0
    t.integer  "minRateChild",                                           default: 0
    t.integer  "minRateInfant",                                          default: 0
    t.integer  "maxRateAdult",                                           default: 0
    t.integer  "maxRateChild",                                           default: 0
    t.integer  "maxRateInfant",                                          default: 0
    t.integer  "duration",            limit: 8,                          default: 0
    t.text     "specialNotes",                                           default: ""
    t.integer  "operatingDays",                                          default: 0
    t.text     "operatingDaysStr",                                       default: ""
    t.text     "operatingSchedule",                                      default: ""
    t.text     "locationStart",                                          default: ""
    t.decimal  "latitudeStart",                 precision: 10, scale: 6
    t.decimal  "longitudeStart",                precision: 10, scale: 6
    t.integer  "distanceStartToRef",                                     default: 0
    t.text     "locationEnd",                                            default: ""
    t.decimal  "latitudeEnd",                   precision: 10, scale: 6
    t.decimal  "longitudeEnd",                  precision: 10, scale: 6
    t.string   "tags",                                                   default: [],    array: true
    t.integer  "minAge",                                                 default: 0
    t.integer  "maxAge",                                                 default: 0
    t.integer  "requiredMultiple",                                       default: 0
    t.integer  "minUnits",                                               default: 0
    t.integer  "maxUnits",                                               default: 0
    t.text     "pickupNotes",                                            default: ""
    t.text     "dropoffNotes",                                           default: ""
    t.text     "highlightsStr",                                          default: ""
    t.text     "itineraryStr",                                           default: ""
    t.text     "includes",                                               default: ""
    t.text     "sellVouchers",                                           default: ""
    t.text     "onlyVouchers",                                           default: ""
    t.text     "voucherInstructions",                                    default: ""
    t.integer  "voucherValidity",                                        default: 0
    t.text     "customStr1",                                             default: ""
    t.text     "customStr2",                                             default: ""
    t.text     "customStr3",                                             default: ""
    t.text     "customStr4",                                             default: ""
    t.boolean  "pickupRequired",                                         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "livn_product_id"
    t.date     "startDate"
    t.date     "endDate"
    t.decimal  "page_ranking_weight"
    t.text     "focus_keyword"
    t.text     "seo_title"
    t.string   "shopify_product_id"
  end

  add_index "offers", ["attraction_id"], name: "index_offers_on_attraction_id", using: :btree
  add_index "offers", ["shopify_product_id"], name: "index_offers_on_shopify_product_id", using: :btree

  create_table "offers_attractions", force: true do |t|
    t.integer "offer_id"
    t.integer "attraction_id"
  end

  add_index "offers_attractions", ["offer_id", "attraction_id"], name: "index_offers_attractions_on_offer_id_and_attraction_id", unique: true, using: :btree
  add_index "offers_attractions", ["offer_id"], name: "index_offers_attractions_on_offer_id", using: :btree

  create_table "offers_countries", force: true do |t|
    t.integer "offer_id"
    t.integer "country_id"
  end

  add_index "offers_countries", ["offer_id", "country_id"], name: "index_offers_countries_on_offer_id_and_country_id", unique: true, using: :btree
  add_index "offers_countries", ["offer_id"], name: "index_offers_countries_on_offer_id", using: :btree

  create_table "offers_photos", force: true do |t|
    t.integer "photo_id"
    t.integer "offer_id"
  end

  add_index "offers_photos", ["offer_id", "photo_id"], name: "index_offers_photos_on_offer_id_and_photo_id", unique: true, using: :btree
  add_index "offers_photos", ["offer_id"], name: "index_offers_photos_on_offer_id", using: :btree

  create_table "offers_places", force: true do |t|
    t.integer "offer_id"
    t.integer "place_id"
  end

  add_index "offers_places", ["offer_id", "place_id"], name: "index_offers_places_on_offer_id_and_place_id", unique: true, using: :btree
  add_index "offers_places", ["offer_id"], name: "index_offers_places_on_offer_id", using: :btree

  create_table "offers_regions", force: true do |t|
    t.integer "offer_id"
    t.integer "region_id"
  end

  add_index "offers_regions", ["offer_id", "region_id"], name: "index_offers_regions_on_offer_id_and_region_id", unique: true, using: :btree
  add_index "offers_regions", ["offer_id"], name: "index_offers_regions_on_offer_id", using: :btree

  create_table "offers_subcategories", force: true do |t|
    t.integer "offer_id"
    t.integer "subcategory_id"
  end

  add_index "offers_subcategories", ["offer_id", "subcategory_id"], name: "index_offers_subcategories_on_offer_id_and_subcategory_id", unique: true, using: :btree
  add_index "offers_subcategories", ["offer_id"], name: "index_offers_subcategories_on_offer_id", using: :btree

  create_table "offers_users", force: true do |t|
    t.integer "user_id"
    t.integer "offer_id"
  end

  create_table "offers_videos", force: true do |t|
    t.integer "offer_id"
    t.integer "video_id"
  end

  add_index "offers_videos", ["offer_id", "video_id"], name: "index_offers_videos_on_offer_id_and_video_id", unique: true, using: :btree
  add_index "offers_videos", ["offer_id"], name: "index_offers_videos_on_offer_id", using: :btree

  create_table "one_minute_forms", force: true do |t|
    t.string   "results"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "offer_id"
    t.integer  "user_id"
    t.string   "title"
    t.integer  "number_of_children", default: 0
    t.integer  "number_of_adults",   default: 0
    t.integer  "number_of_infants",  default: 0
    t.integer  "total_price",        default: 0
    t.date     "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shopify_order_id"
  end

  add_index "orders", ["offer_id", "user_id"], name: "index_orders_on_offer_id_and_user_id", using: :btree

  create_table "overall_averages", force: true do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "overall_avg",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.string   "title",           null: false
    t.string   "hero_image"
    t.text     "hero_image_text"
    t.text     "promo_headline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "page_header"
  end

  add_index "pages", ["title"], name: "index_pages_on_title", unique: true, using: :btree

  create_table "pg_search_documents", force: true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_id", "searchable_type"], name: "index_pg_search_documents_on_searchable_id_and_searchable_type", using: :btree

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
    t.boolean  "country_include"
    t.boolean  "customer_review"
    t.boolean  "customer_approved"
    t.datetime "approved_at"
    t.boolean  "hero"
    t.boolean  "country_hero"
    t.integer  "attraction_id"
    t.integer  "photoable_id"
    t.string   "photoable_type"
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
    t.string   "state"
    t.string   "place_id"
    t.string   "status"
    t.datetime "published_at"
    t.datetime "unpublished_at"
    t.boolean  "user_created"
    t.string   "created_by"
    t.integer  "country_id"
    t.boolean  "customer_review"
    t.boolean  "customer_approved"
    t.datetime "approved_at"
    t.integer  "user_id"
    t.boolean  "show_on_school_safari",     default: false
    t.text     "school_safari_description"
    t.string   "hero_image"
    t.string   "bound_round_place_id"
    t.boolean  "is_area",                   default: false
    t.text     "meta_description"
    t.string   "weather_conditions"
    t.integer  "primary_category_id"
    t.integer  "minimum_age"
    t.integer  "maximum_age"
    t.text     "special_requirements"
    t.boolean  "top_100",                   default: false
    t.text     "viator_link",               default: ""
    t.boolean  "footer_include"
    t.boolean  "primary_area"
    t.string   "algolia_id"
    t.string   "email"
    t.integer  "parent_id"
    t.string   "trip_advisor_url"
    t.decimal  "page_ranking_weight"
    t.integer  "algolia_clicks",            default: 0
    t.text     "focus_keyword"
    t.text     "seo_title"
  end

  add_index "places", ["area_id"], name: "index_places_on_area_id", using: :btree
  add_index "places", ["bound_round_place_id"], name: "index_places_on_bound_round_place_id", unique: true, using: :btree
  add_index "places", ["country_id"], name: "index_places_on_country_id", using: :btree
  add_index "places", ["display_name"], name: "index_places_on_display_name", using: :btree
  add_index "places", ["parent_id"], name: "index_places_on_parent_id", using: :btree
  add_index "places", ["primary_category_id"], name: "index_places_on_primary_category_id", using: :btree
  add_index "places", ["slug"], name: "index_places_on_slug", using: :btree
  add_index "places", ["user_id"], name: "index_places_on_user_id", using: :btree

  create_table "places_posts", id: false, force: true do |t|
    t.integer "place_id", null: false
    t.integer "post_id",  null: false
  end

  add_index "places_posts", ["place_id", "post_id"], name: "index_places_posts_on_place_id_and_post_id", using: :btree
  add_index "places_posts", ["post_id", "place_id"], name: "index_places_posts_on_post_id_and_place_id", using: :btree

  create_table "places_stories", force: true do |t|
    t.integer  "place_id"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places_stories", ["place_id", "story_id"], name: "index_places_stories_on_place_id_and_story_id", unique: true, using: :btree

  create_table "places_subcategories", force: true do |t|
    t.integer "place_id",       null: false
    t.integer "subcategory_id", null: false
    t.text    "desc"
  end

  add_index "places_subcategories", ["place_id", "subcategory_id"], name: "index_places_subcategories_on_place_id_and_subcategory_id", using: :btree
  add_index "places_subcategories", ["subcategory_id", "place_id"], name: "index_places_subcategories_on_subcategory_id_and_place_id", using: :btree

  create_table "places_users", force: true do |t|
    t.integer "user_id",  null: false
    t.integer "place_id", null: false
  end

  add_index "places_users", ["place_id", "user_id"], name: "index_places_users_on_place_id_and_user_id", unique: true, using: :btree

  create_table "points_balances", force: true do |t|
    t.integer  "user_id"
    t.integer  "balance",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "points_balances", ["user_id"], name: "index_points_balances_on_user_id", using: :btree

  create_table "points_values", force: true do |t|
    t.string   "asset_type"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "status"
    t.string   "credit"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.datetime "publish_date"
    t.text     "seo_friendly_url"
    t.integer  "minimum_age"
    t.integer  "maximum_age"
    t.integer  "primary_category_id"
    t.string   "hero_photo"
    t.decimal  "page_ranking_weight"
    t.integer  "algolia_clicks",      default: 0
  end

  add_index "posts", ["primary_category_id"], name: "index_posts_on_primary_category_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "posts_subcategories", id: false, force: true do |t|
    t.integer "post_id",        null: false
    t.integer "subcategory_id", null: false
  end

  add_index "posts_subcategories", ["post_id", "subcategory_id"], name: "index_posts_subcategories_on_post_id_and_subcategory_id", using: :btree
  add_index "posts_subcategories", ["subcategory_id", "post_id"], name: "index_posts_subcategories_on_subcategory_id_and_post_id", using: :btree

  create_table "posts_users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.integer  "user_id"
  end

  add_index "posts_users", ["user_id", "post_id"], name: "index_posts_users_on_user_id_and_post_id", unique: true, using: :btree

  create_table "primary_categories", force: true do |t|
    t.string   "name"
    t.string   "identifier"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "attraction_id"
  end

  add_index "programs", ["place_id"], name: "index_programs_on_place_id", using: :btree

  create_table "rates", force: true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "stars",         null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type", using: :btree
  add_index "rates", ["rater_id"], name: "index_rates_on_rater_id", using: :btree

  create_table "rating_caches", force: true do |t|
    t.integer  "cacheable_id"
    t.string   "cacheable_type"
    t.float    "avg",            null: false
    t.integer  "qty",            null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rating_caches", ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type", using: :btree

  create_table "regions", force: true do |t|
    t.string   "display_name"
    t.string   "slug"
    t.text     "description"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.integer  "zoom_level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",       default: ""
  end

  create_table "regions_stories", force: true do |t|
    t.integer  "region_id"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions_users", force: true do |t|
    t.integer "user_id"
    t.integer "region_id"
  end

  create_table "reviews", force: true do |t|
    t.text     "content"
    t.integer  "reviewable_id"
    t.string   "reviewable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "title"
    t.string   "status"
    t.string   "google_place_id"
    t.boolean  "user_notified"
    t.datetime "user_notified_at"
    t.integer  "country_id"
  end

  add_index "reviews", ["reviewable_id", "reviewable_type"], name: "index_reviews_on_reviewable_id_and_reviewable_type", using: :btree

  create_table "reviews_users", force: true do |t|
    t.integer "user_id",   null: false
    t.integer "review_id", null: false
  end

  add_index "reviews_users", ["user_id", "review_id"], name: "index_reviews_users_on_user_id_and_review_id", using: :btree

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

  create_table "search_requests", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "term"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_suggestions", force: true do |t|
    t.string   "term"
    t.integer  "popularity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "similar_attractions", force: true do |t|
    t.integer  "attraction_id"
    t.integer  "similar_place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "similar_places", force: true do |t|
    t.integer  "place_id"
    t.integer  "similar_place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "similar_places", ["place_id", "similar_place_id"], name: "index_similar_places_on_place_id_and_similar_place_id", unique: true, using: :btree
  add_index "similar_places", ["place_id"], name: "index_similar_places_on_place_id", using: :btree
  add_index "similar_places", ["similar_place_id"], name: "index_similar_places_on_similar_place_id", using: :btree

  create_table "stamp_transactions", force: true do |t|
    t.string  "user_info"
    t.integer "stamp_id"
  end

  add_index "stamp_transactions", ["stamp_id"], name: "index_stamp_transactions_on_stamp_id", using: :btree

  create_table "stamps", force: true do |t|
    t.string  "serial"
    t.integer "place_id"
    t.integer "attraction_id"
  end

  add_index "stamps", ["place_id"], name: "index_stamps_on_place_id", using: :btree

  create_table "stories", force: true do |t|
    t.text     "title",               default: ""
    t.text     "content",             default: "Tell your story and add images here"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",              default: "draft"
    t.string   "google_place_id"
    t.boolean  "user_notified"
    t.datetime "user_notified_at"
    t.date     "date"
    t.integer  "minimum_age"
    t.integer  "maximum_age"
    t.string   "author_name"
    t.boolean  "public"
    t.string   "slug"
    t.integer  "primary_category_id"
    t.datetime "publish_date"
    t.text     "seo_friendly_url"
    t.decimal  "page_ranking_weight"
    t.integer  "algolia_clicks",      default: 0
    t.string   "hero_image"
    t.text     "focus_keyword"
    t.text     "seo_title"
    t.text     "meta_description"
  end

  add_index "stories", ["primary_category_id"], name: "index_stories_on_primary_category_id", using: :btree
  add_index "stories", ["slug"], name: "index_stories_on_slug", using: :btree
  add_index "stories", ["user_id"], name: "index_stories_on_user_id", using: :btree

  create_table "stories_subcategories", force: true do |t|
    t.integer  "subcategory_id"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stories_subcategories", ["story_id", "subcategory_id"], name: "index_stories_subcategories_on_story_id_and_subcategory_id", unique: true, using: :btree

  create_table "stories_users", force: true do |t|
    t.integer "user_id",  null: false
    t.integer "story_id", null: false
  end

  add_index "stories_users", ["story_id", "user_id"], name: "index_stories_users_on_story_id_and_user_id", using: :btree
  add_index "stories_users", ["user_id", "story_id"], name: "index_stories_users_on_user_id_and_story_id", using: :btree

  create_table "story_images", force: true do |t|
    t.string  "file"
    t.integer "story_id"
  end

  create_table "subcategories", force: true do |t|
    t.text     "name"
    t.text     "category_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "identifier"
    t.string   "icon"
    t.text     "primary_description"
    t.text     "secondary_description"
    t.string   "related_to"
    t.string   "slug"
  end

  add_index "subcategories", ["slug"], name: "index_subcategories_on_slug", using: :btree

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

  create_table "three_d_videos", force: true do |t|
    t.text     "link"
    t.string   "caption"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attraction_id"
    t.integer  "three_d_videoable_id"
    t.string   "three_d_videoable_type"
  end

  add_index "three_d_videos", ["place_id"], name: "index_three_d_videos_on_place_id", using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "user_id"
    t.string   "asset_type"
    t.integer  "points"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "asset_id"
  end

  add_index "transactions", ["user_id"], name: "index_transactions_on_user_id", using: :btree

  create_table "user_photos", force: true do |t|
    t.string   "title"
    t.string   "path"
    t.string   "caption"
    t.string   "status"
    t.integer  "user_id"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
    t.integer  "area_id"
    t.integer  "story_priority"
    t.string   "google_place_id"
    t.integer  "priority"
    t.boolean  "user_notified"
    t.datetime "user_notified_at"
    t.string   "google_place_name"
    t.string   "instagram_id"
    t.boolean  "hero"
    t.integer  "country_id"
    t.text     "alt_tag"
    t.integer  "attraction_id"
  end

  add_index "user_photos", ["area_id"], name: "index_user_photos_on_area_id", using: :btree
  add_index "user_photos", ["instagram_id"], name: "index_user_photos_on_instagram_id", unique: true, using: :btree
  add_index "user_photos", ["place_id"], name: "index_user_photos_on_place_id", using: :btree
  add_index "user_photos", ["story_id"], name: "index_user_photos_on_story_id", using: :btree
  add_index "user_photos", ["user_id"], name: "index_user_photos_on_user_id", using: :btree

  create_table "user_photos_users", force: true do |t|
    t.integer "user_id",       null: false
    t.integer "user_photo_id", null: false
  end

  add_index "user_photos_users", ["user_id", "user_photo_id"], name: "index_user_photos_users_on_user_id_and_user_photo_id", using: :btree
  add_index "user_photos_users", ["user_photo_id", "user_id"], name: "index_user_photos_users_on_user_photo_id_and_user_id", using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
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
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "address"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "post_code"
    t.integer  "min_age"
    t.integer  "max_age"
    t.boolean  "is_private",             default: true
    t.text     "description"
    t.string   "gender"
    t.string   "mobile"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
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
    t.boolean  "country_include"
    t.boolean  "customer_review"
    t.boolean  "customer_approved"
    t.datetime "approved_at"
    t.string   "title"
    t.text     "description"
    t.boolean  "hero"
    t.string   "youtube_id",        default: ""
    t.text     "transcript"
    t.integer  "attraction_id"
    t.integer  "videoable_id"
    t.string   "videoable_type"
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
