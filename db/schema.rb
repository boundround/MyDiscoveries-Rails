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

ActiveRecord::Schema.define(version: 20180607004624) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "attraction_types", force: true do |t|
    t.string   "name",       default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "attraction_type_id"
  end

  add_index "attractions", ["attraction_type_id"], name: "index_attractions_on_attraction_type_id", using: :btree
  add_index "attractions", ["country_id"], name: "index_attractions_on_country_id", using: :btree
  add_index "attractions", ["primary_category_id"], name: "index_attractions_on_primary_category_id", using: :btree
  add_index "attractions", ["user_id"], name: "index_attractions_on_user_id", using: :btree

  create_table "attractions_places", id: false, force: true do |t|
    t.integer "attraction_id"
    t.integer "place_id"
  end

  add_index "attractions_places", ["attraction_id"], name: "index_attractions_places_on_attraction_id", using: :btree
  add_index "attractions_places", ["place_id"], name: "index_attractions_places_on_place_id", using: :btree

  create_table "attractions_posts", force: true do |t|
    t.integer "attraction_id"
    t.integer "post_id"
  end

  create_table "attractions_regions", id: false, force: true do |t|
    t.integer "attraction_id"
    t.integer "region_id"
  end

  add_index "attractions_regions", ["attraction_id"], name: "index_attractions_regions_on_attraction_id", using: :btree
  add_index "attractions_regions", ["region_id"], name: "index_attractions_regions_on_region_id", using: :btree

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

  create_table "authors", force: true do |t|
    t.string   "name"
    t.string   "link"
    t.string   "image"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors_users", force: true do |t|
    t.integer "author_id"
    t.integer "user_id"
  end

  add_index "authors_users", ["author_id", "user_id"], name: "index_authors_users_on_author_id_and_user_id", unique: true, using: :btree

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
    t.string   "itemable_type",   default: "", null: false
    t.integer  "itemable_id",     default: 0,  null: false
    t.string   "parentable_type", default: "", null: false
    t.integer  "parentable_id",   default: 0,  null: false
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

  create_table "configurables", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "configurables", ["name"], name: "index_configurables_on_name", using: :btree

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

  create_table "customers", force: true do |t|
    t.string   "title"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "address_one"
    t.string   "address_two"
    t.string   "address_three"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.boolean  "is_primary"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.boolean  "created_from_ax", default: false
  end

  add_index "customers", ["user_id"], name: "index_customers_on_user_id", using: :btree

  create_table "customers_attractions", force: true do |t|
    t.integer "user_id"
    t.integer "attraction_id"
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
    t.integer  "famous_faceable_id"
    t.string   "famous_faceable_type"
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "friendly_id_slugs", ["deleted_at"], name: "index_friendly_id_slugs_on_deleted_at", using: :btree
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

  create_table "landings", force: true do |t|
    t.string   "from_url"
    t.string   "to_url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "landings", ["user_id"], name: "index_landings_on_user_id", using: :btree

  create_table "offers", force: true do |t|
    t.integer  "attraction_id"
    t.string   "status",                                                        default: ""
    t.text     "name",                                                          default: ""
    t.text     "description",                                                   default: ""
    t.integer  "minRateAdult",                                                  default: 0
    t.integer  "minRateChild",                                                  default: 0
    t.integer  "minRateInfant",                                                 default: 0
    t.integer  "maxRateAdult",                                                  default: 0
    t.integer  "maxRateChild",                                                  default: 0
    t.integer  "maxRateInfant",                                                 default: 0
    t.integer  "duration",                   limit: 8,                          default: 0
    t.text     "specialNotes",                                                  default: ""
    t.integer  "operatingDays",                                                 default: 0
    t.text     "operatingDaysStr",                                              default: ""
    t.text     "operatingSchedule",                                             default: ""
    t.text     "locationStart",                                                 default: ""
    t.decimal  "latitudeStart",                        precision: 10, scale: 6
    t.decimal  "longitudeStart",                       precision: 10, scale: 6
    t.integer  "distanceStartToRef",                                            default: 0
    t.text     "locationEnd",                                                   default: ""
    t.decimal  "latitudeEnd",                          precision: 10, scale: 6
    t.decimal  "longitudeEnd",                         precision: 10, scale: 6
    t.string   "tags",                                                          default: [],    array: true
    t.integer  "minAge",                                                        default: 0
    t.integer  "maxAge",                                                        default: 0
    t.integer  "requiredMultiple",                                              default: 0
    t.integer  "minUnits",                                                      default: 0
    t.integer  "maxUnits",                                                      default: 0
    t.text     "pickupNotes",                                                   default: ""
    t.text     "dropoffNotes",                                                  default: ""
    t.text     "highlightsStr",                                                 default: ""
    t.text     "itineraryStr",                                                  default: ""
    t.text     "includes",                                                      default: ""
    t.text     "sellVouchers",                                                  default: ""
    t.text     "onlyVouchers",                                                  default: ""
    t.text     "voucherInstructions",                                           default: ""
    t.integer  "voucherValidity",                                               default: 0
    t.text     "customStr1",                                                    default: ""
    t.text     "customStr2",                                                    default: ""
    t.text     "customStr3",                                                    default: ""
    t.text     "customStr4",                                                    default: ""
    t.boolean  "pickupRequired",                                                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "livn_product_id"
    t.date     "startDate"
    t.date     "endDate"
    t.decimal  "page_ranking_weight"
    t.text     "focus_keyword"
    t.text     "seo_title"
    t.string   "shopify_product_id"
    t.string   "slug"
    t.integer  "operator_id"
    t.date     "validityStartDate"
    t.date     "validityEndDate"
    t.date     "publishstartdate"
    t.date     "publishenddate"
    t.integer  "place_id"
    t.string   "supplier_product_code"
    t.string   "innovations_transaction_id"
    t.boolean  "show_in_mega_menu",                                             default: false
    t.boolean  "featured",                                                      default: false
    t.boolean  "allow_installments",                                            default: false
    t.string   "child_item_id",                                                 default: ""
    t.string   "item_id",                                                       default: ""
    t.string   "places_visited",                                                default: [],    array: true
    t.integer  "number_of_days"
    t.integer  "number_of_nights"
    t.string   "itinerary"
    t.boolean  "test_product",                                                  default: false
  end

  add_index "offers", ["attraction_id"], name: "index_offers_on_attraction_id", using: :btree
  add_index "offers", ["place_id"], name: "index_offers_on_place_id", using: :btree
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
    t.string  "shopify_image_id"
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

  create_table "operators", force: true do |t|
    t.string   "status",               default: ""
    t.text     "name",                 default: ""
    t.text     "companyName",          default: ""
    t.string   "code",                 default: ""
    t.text     "tradingName",          default: ""
    t.string   "businessNumber",       default: ""
    t.text     "description",          default: ""
    t.integer  "tncId",                default: 0
    t.boolean  "demo",                 default: false
    t.text     "address1",             default: ""
    t.text     "address2",             default: ""
    t.string   "city",                 default: ""
    t.string   "state",                default: ""
    t.string   "postcode",             default: ""
    t.float    "latitude"
    t.float    "longitude"
    t.string   "country",              default: ""
    t.string   "language",             default: ""
    t.text     "contactName",          default: ""
    t.string   "email",                default: ""
    t.string   "phone",                default: ""
    t.string   "fax",                  default: ""
    t.string   "website",              default: ""
    t.text     "resContactName",       default: ""
    t.string   "resEmail",             default: ""
    t.string   "resPhone",             default: ""
    t.string   "accountsEmail",        default: ""
    t.string   "currency",             default: ""
    t.text     "logoUrl",              default: ""
    t.string   "tags",                 default: [],    array: true
    t.text     "tncUrl",               default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.text     "contact_job_title",    default: ""
    t.text     "contact_field_office", default: ""
    t.text     "terms_and_conditions", default: ""
    t.string   "contract_pdf_file"
    t.text     "payment_conditions",   default: ""
    t.string   "google_place_id",      default: ""
    t.string   "logo"
    t.string   "xero_id"
    t.string   "hubspot_id"
    t.text     "booking_essentials"
  end

  add_index "operators", ["slug"], name: "index_operators_on_slug", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "offer_id"
    t.integer  "user_id"
    t.string   "title"
    t.integer  "number_of_children",   default: 0
    t.integer  "number_of_adults",     default: 0
    t.integer  "number_of_infants",    default: 0
    t.integer  "total_price",          default: 0
    t.date     "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shopify_order_id"
    t.integer  "status",               default: 0
    t.boolean  "request_installments", default: false
    t.json     "px_response",          default: {}
    t.integer  "customer_id"
    t.boolean  "voucher_sent",         default: false
    t.string   "ax_sales_id"
    t.boolean  "created_from_ax",      default: false
    t.datetime "purchase_date"
    t.json     "ax_data",              default: {}
    t.string   "ax_filename"
  end

  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id", using: :btree
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

  create_table "passengers", force: true do |t|
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "telephone"
    t.string   "mobile"
    t.string   "email"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "line_item_id"
  end

  add_index "passengers", ["line_item_id"], name: "index_passengers_on_line_item_id", using: :btree
  add_index "passengers", ["order_id"], name: "index_passengers_on_order_id", using: :btree

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
    t.string   "description_heading",       default: ""
    t.integer  "zoom_level"
    t.boolean  "is_country",                default: false
    t.boolean  "show_in_mega_menu",         default: false
    t.string   "tags",                      default: [],    array: true
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

  create_table "places_regions", id: false, force: true do |t|
    t.integer "place_id"
    t.integer "region_id"
  end

  add_index "places_regions", ["place_id"], name: "index_places_regions_on_place_id", using: :btree
  add_index "places_regions", ["region_id"], name: "index_places_regions_on_region_id", using: :btree

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

  create_table "product_types", force: true do |t|
    t.string   "name",       default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products_stickers", id: false, force: true do |t|
    t.integer "product_id"
    t.integer "sticker_id"
  end

  add_index "products_stickers", ["product_id", "sticker_id"], name: "index_products_stickers_on_product_id_and_sticker_id", using: :btree
  add_index "products_stickers", ["product_id"], name: "index_products_stickers_on_product_id", using: :btree
  add_index "products_stickers", ["sticker_id", "product_id"], name: "index_products_stickers_on_sticker_id_and_product_id", using: :btree
  add_index "products_stickers", ["sticker_id"], name: "index_products_stickers_on_sticker_id", using: :btree

  create_table "products_stories", id: false, force: true do |t|
    t.integer "product_id"
    t.integer "story_id"
  end

  add_index "products_stories", ["product_id", "story_id"], name: "index_products_stories_on_product_id_and_story_id", using: :btree
  add_index "products_stories", ["product_id"], name: "index_products_stories_on_product_id", using: :btree
  add_index "products_stories", ["story_id", "product_id"], name: "index_products_stories_on_story_id_and_product_id", using: :btree
  add_index "products_stories", ["story_id"], name: "index_products_stories_on_story_id", using: :btree

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

  create_table "related_offers", force: true do |t|
    t.integer  "offer_id"
    t.integer  "related_offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "secondary_tab_infos", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.integer  "secondary_tab_infoable_id"
    t.string   "secondary_tab_infoable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "credit",                      default: ""
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

  create_table "spree_add_on_prices", force: true do |t|
    t.integer  "add_on_id"
    t.decimal  "amount",     precision: 8, scale: 2
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_add_ons", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.string   "type"
    t.boolean  "default",            default: false
    t.integer  "expiration_days"
    t.string   "add_on_type"
    t.boolean  "show_embroidery",    default: false
    t.string   "embroidery_options"
    t.string   "item_code",          default: ""
    t.boolean  "active_for_admin",   default: false
    t.string   "add_on_code",        default: ""
  end

  add_index "spree_add_ons", ["product_id"], name: "index_spree_add_ons_on_product_id", using: :btree

  create_table "spree_addresses", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "state_name"
    t.string   "alternative_phone"
    t.string   "company"
    t.integer  "state_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_addresses", ["country_id"], name: "index_spree_addresses_on_country_id", using: :btree
  add_index "spree_addresses", ["firstname"], name: "index_addresses_on_firstname", using: :btree
  add_index "spree_addresses", ["lastname"], name: "index_addresses_on_lastname", using: :btree
  add_index "spree_addresses", ["state_id"], name: "index_spree_addresses_on_state_id", using: :btree

  create_table "spree_adjustments", force: true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "adjustable_id"
    t.string   "adjustable_type"
    t.decimal  "amount",          precision: 10, scale: 2
    t.string   "label"
    t.boolean  "mandatory"
    t.boolean  "eligible",                                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "order_id",                                                 null: false
    t.boolean  "included",                                 default: false
  end

  add_index "spree_adjustments", ["adjustable_id", "adjustable_type"], name: "index_spree_adjustments_on_adjustable_id_and_adjustable_type", using: :btree
  add_index "spree_adjustments", ["adjustable_id"], name: "index_adjustments_on_order_id", using: :btree
  add_index "spree_adjustments", ["eligible"], name: "index_spree_adjustments_on_eligible", using: :btree
  add_index "spree_adjustments", ["order_id"], name: "index_spree_adjustments_on_order_id", using: :btree
  add_index "spree_adjustments", ["source_id", "source_type"], name: "index_spree_adjustments_on_source_id_and_source_type", using: :btree

  create_table "spree_assets", force: true do |t|
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.integer  "attachment_width"
    t.integer  "attachment_height"
    t.integer  "attachment_file_size"
    t.integer  "position"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.string   "type",                    limit: 75
    t.datetime "attachment_updated_at"
    t.text     "alt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_assets", ["viewable_id"], name: "index_assets_on_viewable_id", using: :btree
  add_index "spree_assets", ["viewable_type", "type"], name: "index_assets_on_viewable_type_and_type", using: :btree

  create_table "spree_calculators", force: true do |t|
    t.string   "type"
    t.integer  "calculable_id"
    t.string   "calculable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "preferences"
    t.datetime "deleted_at"
  end

  add_index "spree_calculators", ["calculable_id", "calculable_type"], name: "index_spree_calculators_on_calculable_id_and_calculable_type", using: :btree
  add_index "spree_calculators", ["deleted_at"], name: "index_spree_calculators_on_deleted_at", using: :btree
  add_index "spree_calculators", ["id", "type"], name: "index_spree_calculators_on_id_and_type", using: :btree

  create_table "spree_configurations", force: true do |t|
    t.string   "name"
    t.string   "type",       limit: 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_configurations", ["name", "type"], name: "index_spree_configurations_on_name_and_type", using: :btree

  create_table "spree_countries", force: true do |t|
    t.string   "iso_name"
    t.string   "iso"
    t.string   "iso3"
    t.string   "name"
    t.integer  "numcode"
    t.boolean  "states_required", default: false
    t.datetime "updated_at"
  end

  create_table "spree_credit_cards", force: true do |t|
    t.string   "month"
    t.string   "year"
    t.string   "cc_type"
    t.string   "last_digits"
    t.integer  "address_id"
    t.string   "gateway_customer_profile_id"
    t.string   "gateway_payment_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "user_id"
    t.integer  "payment_method_id"
    t.boolean  "default",                     default: false, null: false
  end

  add_index "spree_credit_cards", ["address_id"], name: "index_spree_credit_cards_on_address_id", using: :btree
  add_index "spree_credit_cards", ["payment_method_id"], name: "index_spree_credit_cards_on_payment_method_id", using: :btree
  add_index "spree_credit_cards", ["user_id"], name: "index_spree_credit_cards_on_user_id", using: :btree

  create_table "spree_customer_returns", force: true do |t|
    t.string   "number"
    t.integer  "stock_location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_gateways", force: true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      default: true
    t.string   "environment", default: "development"
    t.string   "server",      default: "test"
    t.boolean  "test_mode",   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "preferences"
  end

  add_index "spree_gateways", ["active"], name: "index_spree_gateways_on_active", using: :btree
  add_index "spree_gateways", ["test_mode"], name: "index_spree_gateways_on_test_mode", using: :btree

  create_table "spree_inventory_units", force: true do |t|
    t.string   "state"
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "shipment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pending",      default: true
    t.integer  "line_item_id"
  end

  add_index "spree_inventory_units", ["line_item_id"], name: "index_spree_inventory_units_on_line_item_id", using: :btree
  add_index "spree_inventory_units", ["order_id"], name: "index_inventory_units_on_order_id", using: :btree
  add_index "spree_inventory_units", ["shipment_id"], name: "index_inventory_units_on_shipment_id", using: :btree
  add_index "spree_inventory_units", ["variant_id"], name: "index_inventory_units_on_variant_id", using: :btree

  create_table "spree_line_item_add_ons", force: true do |t|
    t.integer  "add_on_id"
    t.integer  "line_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price",            precision: 8, scale: 2
    t.datetime "expiration_date"
    t.string   "embroidery_text"
    t.string   "embroidery_font"
    t.string   "embroidery_color"
  end

  create_table "spree_line_items", force: true do |t|
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "quantity",                                                      null: false
    t.decimal  "price",                precision: 10, scale: 2,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
    t.decimal  "cost_price",           precision: 10, scale: 2
    t.integer  "tax_category_id"
    t.decimal  "adjustment_total",     precision: 10, scale: 2, default: 0.0
    t.decimal  "additional_tax_total", precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",          precision: 10, scale: 2, default: 0.0
    t.decimal  "included_tax_total",   precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "pre_tax_amount",       precision: 8,  scale: 2, default: 0.0
    t.boolean  "request_installments",                          default: false
    t.string   "name"
    t.text     "description"
    t.text     "pickup_address",                                default: ""
    t.text     "dropoff_airport",                               default: ""
  end

  add_index "spree_line_items", ["order_id"], name: "index_spree_line_items_on_order_id", using: :btree
  add_index "spree_line_items", ["tax_category_id"], name: "index_spree_line_items_on_tax_category_id", using: :btree
  add_index "spree_line_items", ["variant_id"], name: "index_spree_line_items_on_variant_id", using: :btree

  create_table "spree_log_entries", force: true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_log_entries", ["source_id", "source_type"], name: "index_spree_log_entries_on_source_id_and_source_type", using: :btree

  create_table "spree_option_types", force: true do |t|
    t.string   "name",         limit: 100
    t.string   "presentation", limit: 100
    t.integer  "position",                 default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_option_types", ["position"], name: "index_spree_option_types_on_position", using: :btree

  create_table "spree_option_types_prototypes", id: false, force: true do |t|
    t.integer "prototype_id"
    t.integer "option_type_id"
  end

  create_table "spree_option_values", force: true do |t|
    t.integer  "position"
    t.string   "name"
    t.string   "presentation"
    t.integer  "option_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_option_values", ["option_type_id"], name: "index_spree_option_values_on_option_type_id", using: :btree
  add_index "spree_option_values", ["position"], name: "index_spree_option_values_on_position", using: :btree

  create_table "spree_option_values_variants", id: false, force: true do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
  end

  add_index "spree_option_values_variants", ["variant_id", "option_value_id"], name: "index_option_values_variants_on_variant_id_and_option_value_id", using: :btree
  add_index "spree_option_values_variants", ["variant_id"], name: "index_spree_option_values_variants_on_variant_id", using: :btree

  create_table "spree_orders", force: true do |t|
    t.string   "number",                 limit: 32
    t.decimal  "item_total",                        precision: 10, scale: 2, default: 0.0,     null: false
    t.decimal  "total",                             precision: 10, scale: 2, default: 0.0,     null: false
    t.string   "state"
    t.decimal  "adjustment_total",                  precision: 10, scale: 2, default: 0.0,     null: false
    t.integer  "user_id"
    t.datetime "completed_at"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
    t.decimal  "payment_total",                     precision: 10, scale: 2, default: 0.0
    t.integer  "shipping_method_id"
    t.string   "shipment_state"
    t.string   "payment_state"
    t.string   "email"
    t.text     "special_instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
    t.string   "last_ip_address"
    t.integer  "created_by_id"
    t.decimal  "shipment_total",                    precision: 10, scale: 2, default: 0.0,     null: false
    t.decimal  "additional_tax_total",              precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",                       precision: 10, scale: 2, default: 0.0
    t.string   "channel",                                                    default: "spree"
    t.decimal  "included_tax_total",                precision: 10, scale: 2, default: 0.0,     null: false
    t.integer  "item_count",                                                 default: 0
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.boolean  "confirmation_delivered",                                     default: false
    t.boolean  "considered_risky",                                           default: false
    t.string   "guest_token"
    t.datetime "canceled_at"
    t.integer  "canceler_id"
    t.integer  "store_id"
    t.integer  "state_lock_version",                                         default: 0,       null: false
    t.integer  "product_id"
    t.string   "title"
    t.integer  "number_of_children",                                         default: 0
    t.integer  "number_of_adults",                                           default: 0
    t.integer  "number_of_infants",                                          default: 0
    t.integer  "total_price",                                                default: 0
    t.date     "start_date"
    t.boolean  "authorized",                                                 default: false
    t.boolean  "request_installments",                                       default: false
    t.json     "px_response",                                                default: {}
    t.integer  "customer_id"
    t.boolean  "voucher_sent",                                               default: false
    t.string   "ax_sales_id"
    t.boolean  "created_from_ax",                                            default: false
    t.datetime "purchase_date"
    t.string   "ax_filename"
    t.json     "ax_data",                                                    default: {}
    t.boolean  "miscellaneous_charges",                                      default: false
    t.text     "description"
    t.string   "hubspot_id",                                                 default: ""
    t.boolean  "sent_to_sna",                                                default: false
    t.text     "sna_response",                                               default: ""
    t.string   "campaign_code",                                              default: ""
  end

  add_index "spree_orders", ["approver_id"], name: "index_spree_orders_on_approver_id", using: :btree
  add_index "spree_orders", ["bill_address_id"], name: "index_spree_orders_on_bill_address_id", using: :btree
  add_index "spree_orders", ["completed_at"], name: "index_spree_orders_on_completed_at", using: :btree
  add_index "spree_orders", ["confirmation_delivered"], name: "index_spree_orders_on_confirmation_delivered", using: :btree
  add_index "spree_orders", ["considered_risky"], name: "index_spree_orders_on_considered_risky", using: :btree
  add_index "spree_orders", ["created_by_id"], name: "index_spree_orders_on_created_by_id", using: :btree
  add_index "spree_orders", ["customer_id"], name: "index_spree_orders_on_customer_id", using: :btree
  add_index "spree_orders", ["guest_token"], name: "index_spree_orders_on_guest_token", using: :btree
  add_index "spree_orders", ["number"], name: "index_spree_orders_on_number", using: :btree
  add_index "spree_orders", ["product_id"], name: "index_spree_orders_on_product_id", using: :btree
  add_index "spree_orders", ["ship_address_id"], name: "index_spree_orders_on_ship_address_id", using: :btree
  add_index "spree_orders", ["shipping_method_id"], name: "index_spree_orders_on_shipping_method_id", using: :btree
  add_index "spree_orders", ["user_id", "created_by_id"], name: "index_spree_orders_on_user_id_and_created_by_id", using: :btree
  add_index "spree_orders", ["user_id"], name: "index_spree_orders_on_user_id", using: :btree

  create_table "spree_orders_promotions", id: false, force: true do |t|
    t.integer "order_id"
    t.integer "promotion_id"
  end

  add_index "spree_orders_promotions", ["order_id", "promotion_id"], name: "index_spree_orders_promotions_on_order_id_and_promotion_id", using: :btree

  create_table "spree_payment_capture_events", force: true do |t|
    t.decimal  "amount",     precision: 10, scale: 2, default: 0.0
    t.integer  "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_payment_capture_events", ["payment_id"], name: "index_spree_payment_capture_events_on_payment_id", using: :btree

  create_table "spree_payment_methods", force: true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",       default: true
    t.string   "environment",  default: "development"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_on"
    t.boolean  "auto_capture"
    t.text     "preferences"
  end

  add_index "spree_payment_methods", ["id", "type"], name: "index_spree_payment_methods_on_id_and_type", using: :btree

  create_table "spree_payments", force: true do |t|
    t.decimal  "amount",               precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "order_id"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "payment_method_id"
    t.string   "state"
    t.string   "response_code"
    t.string   "avs_response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "identifier"
    t.string   "cvv_response_code"
    t.string   "cvv_response_message"
  end

  add_index "spree_payments", ["order_id"], name: "index_spree_payments_on_order_id", using: :btree
  add_index "spree_payments", ["payment_method_id"], name: "index_spree_payments_on_payment_method_id", using: :btree
  add_index "spree_payments", ["source_id", "source_type"], name: "index_spree_payments_on_source_id_and_source_type", using: :btree

  create_table "spree_preferences", force: true do |t|
    t.text     "value"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_preferences", ["key"], name: "index_spree_preferences_on_key", unique: true, using: :btree

  create_table "spree_prices", force: true do |t|
    t.integer  "variant_id",                          null: false
    t.decimal  "amount",     precision: 10, scale: 2
    t.string   "currency"
    t.datetime "deleted_at"
  end

  add_index "spree_prices", ["deleted_at"], name: "index_spree_prices_on_deleted_at", using: :btree
  add_index "spree_prices", ["variant_id", "currency"], name: "index_spree_prices_on_variant_id_and_currency", using: :btree

  create_table "spree_product_option_types", force: true do |t|
    t.integer  "position"
    t.integer  "product_id"
    t.integer  "option_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_product_option_types", ["option_type_id"], name: "index_spree_product_option_types_on_option_type_id", using: :btree
  add_index "spree_product_option_types", ["position"], name: "index_spree_product_option_types_on_position", using: :btree
  add_index "spree_product_option_types", ["product_id"], name: "index_spree_product_option_types_on_product_id", using: :btree

  create_table "spree_product_properties", force: true do |t|
    t.string   "value"
    t.integer  "product_id"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",    default: 0
  end

  add_index "spree_product_properties", ["position"], name: "index_spree_product_properties_on_position", using: :btree
  add_index "spree_product_properties", ["product_id"], name: "index_product_properties_on_product_id", using: :btree
  add_index "spree_product_properties", ["property_id"], name: "index_spree_product_properties_on_property_id", using: :btree

  create_table "spree_products", force: true do |t|
    t.string   "name",                                                          default: "",    null: false
    t.text     "description"
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string   "slug"
    t.text     "meta_description"
    t.string   "meta_keywords"
    t.integer  "tax_category_id"
    t.integer  "shipping_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "promotionable",                                                 default: true
    t.string   "meta_title"
    t.integer  "attraction_id"
    t.string   "status",                                                        default: ""
    t.integer  "minRateAdult",                                                  default: 0
    t.integer  "minRateChild",                                                  default: 0
    t.integer  "minRateInfant",                                                 default: 0
    t.integer  "maxRateAdult",                                                  default: 0
    t.integer  "maxRateChild",                                                  default: 0
    t.integer  "maxRateInfant",                                                 default: 0
    t.integer  "duration",                   limit: 8,                          default: 0
    t.text     "specialNotes",                                                  default: ""
    t.integer  "operatingDays",                                                 default: 0
    t.text     "operatingDaysStr",                                              default: ""
    t.text     "operatingSchedule",                                             default: ""
    t.text     "locationStart",                                                 default: ""
    t.decimal  "latitudeStart",                        precision: 10, scale: 6
    t.decimal  "longitudeStart",                       precision: 10, scale: 6
    t.integer  "distanceStartToRef",                                            default: 0
    t.text     "locationEnd",                                                   default: ""
    t.decimal  "latitudeEnd",                          precision: 10, scale: 6
    t.decimal  "longitudeEnd",                         precision: 10, scale: 6
    t.string   "tags",                                                          default: [],                 array: true
    t.integer  "minAge",                                                        default: 0
    t.integer  "maxAge",                                                        default: 0
    t.integer  "requiredMultiple",                                              default: 0
    t.integer  "minUnits",                                                      default: 0
    t.integer  "maxUnits",                                                      default: 0
    t.text     "pickupNotes",                                                   default: ""
    t.text     "dropoffNotes",                                                  default: ""
    t.text     "highlightsStr",                                                 default: ""
    t.text     "itineraryStr",                                                  default: ""
    t.text     "includes",                                                      default: ""
    t.text     "sellVouchers",                                                  default: ""
    t.text     "onlyVouchers",                                                  default: ""
    t.text     "voucherInstructions",                                           default: ""
    t.integer  "voucherValidity",                                               default: 0
    t.text     "customStr1",                                                    default: ""
    t.text     "customStr2",                                                    default: ""
    t.text     "customStr3",                                                    default: ""
    t.text     "customStr4",                                                    default: ""
    t.boolean  "pickupRequired",                                                default: false
    t.integer  "livn_product_id"
    t.date     "startDate"
    t.date     "endDate"
    t.decimal  "page_ranking_weight"
    t.text     "focus_keyword"
    t.text     "seo_title"
    t.string   "shopify_product_id"
    t.integer  "operator_id"
    t.date     "validityStartDate"
    t.date     "validityEndDate"
    t.date     "publishstartdate"
    t.date     "publishenddate"
    t.integer  "place_id"
    t.string   "supplier_product_code"
    t.string   "innovations_transaction_id"
    t.boolean  "show_in_mega_menu",                                             default: false
    t.boolean  "featured",                                                      default: false
    t.boolean  "allow_installments",                                            default: false
    t.string   "child_item_id",                                                 default: ""
    t.string   "item_id",                                                       default: ""
    t.string   "places_visited",                                                default: [],                 array: true
    t.integer  "number_of_days"
    t.integer  "number_of_nights"
    t.string   "itinerary"
    t.boolean  "test_product",                                                  default: false
    t.string   "departure_dates"
    t.text     "other"
    t.boolean  "add_on",                                                        default: false
    t.boolean  "disable_maturity",                                              default: false
    t.boolean  "disable_bed_type",                                              default: false
    t.boolean  "disable_room_type",                                             default: false
    t.boolean  "disable_package_option",                                        default: false
    t.boolean  "disable_accommodation",                                         default: false
    t.boolean  "disable_departure_date",                                        default: false
    t.boolean  "disable_departure_city",                                        default: false
    t.string   "room_type_label",                                               default: ""
    t.string   "package_option_label",                                          default: ""
    t.text     "voucher_booking_essentials",                                    default: ""
    t.string   "per_adult_overwrite",                                           default: ""
    t.string   "marketing_headline",                                            default: ""
    t.integer  "product_type_id"
    t.boolean  "pickup_dropoff",                                                default: false
    t.boolean  "publishenddate_active",                                         default: false
    t.string   "publishenddate_status",                                         default: ""
    t.integer  "priority",                                                      default: 10
    t.decimal  "full_price",                           precision: 8,  scale: 2, default: 0.0
  end

  add_index "spree_products", ["attraction_id"], name: "index_spree_products_on_attraction_id", using: :btree
  add_index "spree_products", ["available_on"], name: "index_spree_products_on_available_on", using: :btree
  add_index "spree_products", ["deleted_at"], name: "index_spree_products_on_deleted_at", using: :btree
  add_index "spree_products", ["name"], name: "index_spree_products_on_name", using: :btree
  add_index "spree_products", ["place_id"], name: "index_spree_products_on_place_id", using: :btree
  add_index "spree_products", ["shipping_category_id"], name: "index_spree_products_on_shipping_category_id", using: :btree
  add_index "spree_products", ["shopify_product_id"], name: "index_spree_products_on_shopify_product_id", using: :btree
  add_index "spree_products", ["slug"], name: "index_spree_products_on_slug", using: :btree
  add_index "spree_products", ["slug"], name: "permalink_idx_unique", unique: true, using: :btree
  add_index "spree_products", ["tax_category_id"], name: "index_spree_products_on_tax_category_id", using: :btree

  create_table "spree_products_attractions", force: true do |t|
    t.integer  "product_id"
    t.integer  "attraction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_products_countries", force: true do |t|
    t.integer  "product_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_products_photos", force: true do |t|
    t.integer  "photo_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_products_places", force: true do |t|
    t.integer  "product_id"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_products_promotion_rules", id: false, force: true do |t|
    t.integer "product_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_products_promotion_rules", ["product_id"], name: "index_products_promotion_rules_on_product_id", using: :btree
  add_index "spree_products_promotion_rules", ["promotion_rule_id"], name: "index_products_promotion_rules_on_promotion_rule_id", using: :btree

  create_table "spree_products_regions", force: true do |t|
    t.integer  "product_id"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_products_subcategories", force: true do |t|
    t.integer  "product_id"
    t.integer  "subcategory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_products_taxons", force: true do |t|
    t.integer "product_id"
    t.integer "taxon_id"
    t.integer "position"
  end

  add_index "spree_products_taxons", ["position"], name: "index_spree_products_taxons_on_position", using: :btree
  add_index "spree_products_taxons", ["product_id"], name: "index_spree_products_taxons_on_product_id", using: :btree
  add_index "spree_products_taxons", ["taxon_id"], name: "index_spree_products_taxons_on_taxon_id", using: :btree

  create_table "spree_products_users", force: true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_promotion_action_line_items", force: true do |t|
    t.integer "promotion_action_id"
    t.integer "variant_id"
    t.integer "quantity",            default: 1
  end

  add_index "spree_promotion_action_line_items", ["promotion_action_id"], name: "index_spree_promotion_action_line_items_on_promotion_action_id", using: :btree
  add_index "spree_promotion_action_line_items", ["variant_id"], name: "index_spree_promotion_action_line_items_on_variant_id", using: :btree

  create_table "spree_promotion_actions", force: true do |t|
    t.integer  "promotion_id"
    t.integer  "position"
    t.string   "type"
    t.datetime "deleted_at"
  end

  add_index "spree_promotion_actions", ["deleted_at"], name: "index_spree_promotion_actions_on_deleted_at", using: :btree
  add_index "spree_promotion_actions", ["id", "type"], name: "index_spree_promotion_actions_on_id_and_type", using: :btree
  add_index "spree_promotion_actions", ["promotion_id"], name: "index_spree_promotion_actions_on_promotion_id", using: :btree

  create_table "spree_promotion_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_promotion_rules", force: true do |t|
    t.integer  "promotion_id"
    t.integer  "user_id"
    t.integer  "product_group_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.text     "preferences"
  end

  add_index "spree_promotion_rules", ["product_group_id"], name: "index_promotion_rules_on_product_group_id", using: :btree
  add_index "spree_promotion_rules", ["promotion_id"], name: "index_spree_promotion_rules_on_promotion_id", using: :btree
  add_index "spree_promotion_rules", ["user_id"], name: "index_promotion_rules_on_user_id", using: :btree

  create_table "spree_promotion_rules_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_promotion_rules_users", ["promotion_rule_id"], name: "index_promotion_rules_users_on_promotion_rule_id", using: :btree
  add_index "spree_promotion_rules_users", ["user_id"], name: "index_promotion_rules_users_on_user_id", using: :btree

  create_table "spree_promotions", force: true do |t|
    t.string   "description"
    t.datetime "expires_at"
    t.datetime "starts_at"
    t.string   "name"
    t.string   "type"
    t.integer  "usage_limit"
    t.string   "match_policy",          default: "all"
    t.string   "code"
    t.boolean  "advertise",             default: false
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "promotion_category_id"
  end

  add_index "spree_promotions", ["advertise"], name: "index_spree_promotions_on_advertise", using: :btree
  add_index "spree_promotions", ["code"], name: "index_spree_promotions_on_code", using: :btree
  add_index "spree_promotions", ["expires_at"], name: "index_spree_promotions_on_expires_at", using: :btree
  add_index "spree_promotions", ["id", "type"], name: "index_spree_promotions_on_id_and_type", using: :btree
  add_index "spree_promotions", ["promotion_category_id"], name: "index_spree_promotions_on_promotion_category_id", using: :btree
  add_index "spree_promotions", ["starts_at"], name: "index_spree_promotions_on_starts_at", using: :btree

  create_table "spree_properties", force: true do |t|
    t.string   "name"
    t.string   "presentation", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_properties_prototypes", id: false, force: true do |t|
    t.integer "prototype_id"
    t.integer "property_id"
  end

  create_table "spree_prototypes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_refund_reasons", force: true do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.boolean  "mutable",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_refunds", force: true do |t|
    t.integer  "payment_id"
    t.decimal  "amount",           precision: 10, scale: 2, default: 0.0, null: false
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "refund_reason_id"
    t.integer  "reimbursement_id"
  end

  add_index "spree_refunds", ["refund_reason_id"], name: "index_refunds_on_refund_reason_id", using: :btree

  create_table "spree_reimbursement_credits", force: true do |t|
    t.decimal "amount",           precision: 10, scale: 2, default: 0.0, null: false
    t.integer "reimbursement_id"
    t.integer "creditable_id"
    t.string  "creditable_type"
  end

  create_table "spree_reimbursement_types", force: true do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.boolean  "mutable",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  add_index "spree_reimbursement_types", ["type"], name: "index_spree_reimbursement_types_on_type", using: :btree

  create_table "spree_reimbursements", force: true do |t|
    t.string   "number"
    t.string   "reimbursement_status"
    t.integer  "customer_return_id"
    t.integer  "order_id"
    t.decimal  "total",                precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_reimbursements", ["customer_return_id"], name: "index_spree_reimbursements_on_customer_return_id", using: :btree
  add_index "spree_reimbursements", ["order_id"], name: "index_spree_reimbursements_on_order_id", using: :btree

  create_table "spree_related_products", force: true do |t|
    t.integer  "product_id"
    t.integer  "spree_related_product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_return_authorization_reasons", force: true do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.boolean  "mutable",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_return_authorizations", force: true do |t|
    t.string   "number"
    t.string   "state"
    t.integer  "order_id"
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_location_id"
    t.integer  "return_authorization_reason_id"
  end

  add_index "spree_return_authorizations", ["return_authorization_reason_id"], name: "index_return_authorizations_on_return_authorization_reason_id", using: :btree

  create_table "spree_return_items", force: true do |t|
    t.integer  "return_authorization_id"
    t.integer  "inventory_unit_id"
    t.integer  "exchange_variant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "pre_tax_amount",                  precision: 12, scale: 4, default: 0.0, null: false
    t.decimal  "included_tax_total",              precision: 12, scale: 4, default: 0.0, null: false
    t.decimal  "additional_tax_total",            precision: 12, scale: 4, default: 0.0, null: false
    t.string   "reception_status"
    t.string   "acceptance_status"
    t.integer  "customer_return_id"
    t.integer  "reimbursement_id"
    t.integer  "exchange_inventory_unit_id"
    t.text     "acceptance_status_errors"
    t.integer  "preferred_reimbursement_type_id"
    t.integer  "override_reimbursement_type_id"
  end

  add_index "spree_return_items", ["customer_return_id"], name: "index_return_items_on_customer_return_id", using: :btree
  add_index "spree_return_items", ["exchange_inventory_unit_id"], name: "index_spree_return_items_on_exchange_inventory_unit_id", using: :btree

  create_table "spree_roles", force: true do |t|
    t.string "name"
  end

  create_table "spree_roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "spree_roles_users", ["role_id"], name: "index_spree_roles_users_on_role_id", using: :btree
  add_index "spree_roles_users", ["user_id"], name: "index_spree_roles_users_on_user_id", using: :btree

  create_table "spree_shipments", force: true do |t|
    t.string   "tracking"
    t.string   "number"
    t.decimal  "cost",                 precision: 10, scale: 2, default: 0.0
    t.datetime "shipped_at"
    t.integer  "order_id"
    t.integer  "address_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_location_id"
    t.decimal  "adjustment_total",     precision: 10, scale: 2, default: 0.0
    t.decimal  "additional_tax_total", precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",          precision: 10, scale: 2, default: 0.0
    t.decimal  "included_tax_total",   precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "pre_tax_amount",       precision: 8,  scale: 2, default: 0.0
  end

  add_index "spree_shipments", ["address_id"], name: "index_spree_shipments_on_address_id", using: :btree
  add_index "spree_shipments", ["number"], name: "index_shipments_on_number", using: :btree
  add_index "spree_shipments", ["order_id"], name: "index_spree_shipments_on_order_id", using: :btree
  add_index "spree_shipments", ["stock_location_id"], name: "index_spree_shipments_on_stock_location_id", using: :btree

  create_table "spree_shipping_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_shipping_method_categories", force: true do |t|
    t.integer  "shipping_method_id",   null: false
    t.integer  "shipping_category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_shipping_method_categories", ["shipping_category_id", "shipping_method_id"], name: "unique_spree_shipping_method_categories", unique: true, using: :btree
  add_index "spree_shipping_method_categories", ["shipping_method_id"], name: "index_spree_shipping_method_categories_on_shipping_method_id", using: :btree

  create_table "spree_shipping_methods", force: true do |t|
    t.string   "name"
    t.string   "display_on"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tracking_url"
    t.string   "admin_name"
    t.integer  "tax_category_id"
    t.string   "code"
  end

  add_index "spree_shipping_methods", ["deleted_at"], name: "index_spree_shipping_methods_on_deleted_at", using: :btree
  add_index "spree_shipping_methods", ["tax_category_id"], name: "index_spree_shipping_methods_on_tax_category_id", using: :btree

  create_table "spree_shipping_methods_zones", id: false, force: true do |t|
    t.integer "shipping_method_id"
    t.integer "zone_id"
  end

  create_table "spree_shipping_rates", force: true do |t|
    t.integer  "shipment_id"
    t.integer  "shipping_method_id"
    t.boolean  "selected",                                   default: false
    t.decimal  "cost",               precision: 8, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tax_rate_id"
  end

  add_index "spree_shipping_rates", ["selected"], name: "index_spree_shipping_rates_on_selected", using: :btree
  add_index "spree_shipping_rates", ["shipment_id", "shipping_method_id"], name: "spree_shipping_rates_join_index", unique: true, using: :btree
  add_index "spree_shipping_rates", ["tax_rate_id"], name: "index_spree_shipping_rates_on_tax_rate_id", using: :btree

  create_table "spree_state_changes", force: true do |t|
    t.string   "name"
    t.string   "previous_state"
    t.integer  "stateful_id"
    t.integer  "user_id"
    t.string   "stateful_type"
    t.string   "next_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_state_changes", ["stateful_id", "stateful_type"], name: "index_spree_state_changes_on_stateful_id_and_stateful_type", using: :btree
  add_index "spree_state_changes", ["user_id"], name: "index_spree_state_changes_on_user_id", using: :btree

  create_table "spree_states", force: true do |t|
    t.string   "name"
    t.string   "abbr"
    t.integer  "country_id"
    t.datetime "updated_at"
  end

  add_index "spree_states", ["country_id"], name: "index_spree_states_on_country_id", using: :btree

  create_table "spree_stock_items", force: true do |t|
    t.integer  "stock_location_id"
    t.integer  "variant_id"
    t.integer  "count_on_hand",     default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "backorderable",     default: false
    t.datetime "deleted_at"
  end

  add_index "spree_stock_items", ["backorderable"], name: "index_spree_stock_items_on_backorderable", using: :btree
  add_index "spree_stock_items", ["deleted_at"], name: "index_spree_stock_items_on_deleted_at", using: :btree
  add_index "spree_stock_items", ["stock_location_id", "variant_id"], name: "stock_item_by_loc_and_var_id", using: :btree
  add_index "spree_stock_items", ["stock_location_id"], name: "index_spree_stock_items_on_stock_location_id", using: :btree

  create_table "spree_stock_locations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default",                default: false, null: false
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "state_name"
    t.integer  "country_id"
    t.string   "zipcode"
    t.string   "phone"
    t.boolean  "active",                 default: true
    t.boolean  "backorderable_default",  default: false
    t.boolean  "propagate_all_variants", default: true
    t.string   "admin_name"
  end

  add_index "spree_stock_locations", ["active"], name: "index_spree_stock_locations_on_active", using: :btree
  add_index "spree_stock_locations", ["backorderable_default"], name: "index_spree_stock_locations_on_backorderable_default", using: :btree
  add_index "spree_stock_locations", ["country_id"], name: "index_spree_stock_locations_on_country_id", using: :btree
  add_index "spree_stock_locations", ["propagate_all_variants"], name: "index_spree_stock_locations_on_propagate_all_variants", using: :btree
  add_index "spree_stock_locations", ["state_id"], name: "index_spree_stock_locations_on_state_id", using: :btree

  create_table "spree_stock_movements", force: true do |t|
    t.integer  "stock_item_id"
    t.integer  "quantity",        default: 0
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "originator_id"
    t.string   "originator_type"
  end

  add_index "spree_stock_movements", ["stock_item_id"], name: "index_spree_stock_movements_on_stock_item_id", using: :btree

  create_table "spree_stock_transfers", force: true do |t|
    t.string   "type"
    t.string   "reference"
    t.integer  "source_location_id"
    t.integer  "destination_location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "number"
  end

  add_index "spree_stock_transfers", ["destination_location_id"], name: "index_spree_stock_transfers_on_destination_location_id", using: :btree
  add_index "spree_stock_transfers", ["number"], name: "index_spree_stock_transfers_on_number", using: :btree
  add_index "spree_stock_transfers", ["source_location_id"], name: "index_spree_stock_transfers_on_source_location_id", using: :btree

  create_table "spree_stores", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "meta_description"
    t.text     "meta_keywords"
    t.string   "seo_title"
    t.string   "mail_from_address"
    t.string   "default_currency"
    t.string   "code"
    t.boolean  "default",           default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_stores", ["code"], name: "index_spree_stores_on_code", using: :btree
  add_index "spree_stores", ["default"], name: "index_spree_stores_on_default", using: :btree
  add_index "spree_stores", ["url"], name: "index_spree_stores_on_url", using: :btree

  create_table "spree_tax_categories", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "is_default",  default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tax_code"
  end

  add_index "spree_tax_categories", ["deleted_at"], name: "index_spree_tax_categories_on_deleted_at", using: :btree
  add_index "spree_tax_categories", ["is_default"], name: "index_spree_tax_categories_on_is_default", using: :btree

  create_table "spree_tax_rates", force: true do |t|
    t.decimal  "amount",             precision: 8, scale: 5
    t.integer  "zone_id"
    t.integer  "tax_category_id"
    t.boolean  "included_in_price",                          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "show_rate_in_label",                         default: true
    t.datetime "deleted_at"
  end

  add_index "spree_tax_rates", ["deleted_at"], name: "index_spree_tax_rates_on_deleted_at", using: :btree
  add_index "spree_tax_rates", ["included_in_price"], name: "index_spree_tax_rates_on_included_in_price", using: :btree
  add_index "spree_tax_rates", ["show_rate_in_label"], name: "index_spree_tax_rates_on_show_rate_in_label", using: :btree
  add_index "spree_tax_rates", ["tax_category_id"], name: "index_spree_tax_rates_on_tax_category_id", using: :btree
  add_index "spree_tax_rates", ["zone_id"], name: "index_spree_tax_rates_on_zone_id", using: :btree

  create_table "spree_taxonomies", force: true do |t|
    t.string   "name",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   default: 0
  end

  add_index "spree_taxonomies", ["position"], name: "index_spree_taxonomies_on_position", using: :btree

  create_table "spree_taxons", force: true do |t|
    t.integer  "parent_id"
    t.integer  "position",          default: 0
    t.string   "name",                          null: false
    t.string   "permalink"
    t.integer  "taxonomy_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.integer  "depth"
  end

  add_index "spree_taxons", ["parent_id"], name: "index_taxons_on_parent_id", using: :btree
  add_index "spree_taxons", ["permalink"], name: "index_taxons_on_permalink", using: :btree
  add_index "spree_taxons", ["position"], name: "index_spree_taxons_on_position", using: :btree
  add_index "spree_taxons", ["taxonomy_id"], name: "index_taxons_on_taxonomy_id", using: :btree

  create_table "spree_taxons_promotion_rules", force: true do |t|
    t.integer "taxon_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_taxons_promotion_rules", ["promotion_rule_id"], name: "index_spree_taxons_promotion_rules_on_promotion_rule_id", using: :btree
  add_index "spree_taxons_promotion_rules", ["taxon_id"], name: "index_spree_taxons_promotion_rules_on_taxon_id", using: :btree

  create_table "spree_taxons_prototypes", force: true do |t|
    t.integer "taxon_id"
    t.integer "prototype_id"
  end

  add_index "spree_taxons_prototypes", ["prototype_id"], name: "index_spree_taxons_prototypes_on_prototype_id", using: :btree
  add_index "spree_taxons_prototypes", ["taxon_id"], name: "index_spree_taxons_prototypes_on_taxon_id", using: :btree

  create_table "spree_tokenized_permissions", force: true do |t|
    t.integer  "permissable_id"
    t.string   "permissable_type"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_tokenized_permissions", ["permissable_id", "permissable_type"], name: "index_tokenized_name_and_type", using: :btree

  create_table "spree_trackers", force: true do |t|
    t.string   "environment"
    t.string   "analytics_id"
    t.boolean  "active",       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_trackers", ["active"], name: "index_spree_trackers_on_active", using: :btree

  create_table "spree_users", force: true do |t|
    t.string   "encrypted_password",     limit: 128
    t.string   "password_salt",          limit: 128
    t.string   "email"
    t.string   "remember_token"
    t.string   "persistence_token"
    t.string   "reset_password_token"
    t.string   "perishable_token"
    t.integer  "sign_in_count",                      default: 0, null: false
    t.integer  "failed_attempts",                    default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "login"
    t.integer  "ship_address_id"
    t.integer  "bill_address_id"
    t.string   "authentication_token"
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "remember_created_at"
    t.datetime "deleted_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "spree_users", ["deleted_at"], name: "index_spree_users_on_deleted_at", using: :btree
  add_index "spree_users", ["email"], name: "email_idx_unique", unique: true, using: :btree

  create_table "spree_variants", force: true do |t|
    t.string   "sku",                                            default: "",    null: false
    t.decimal  "weight",                precision: 8,  scale: 2, default: 0.0
    t.decimal  "height",                precision: 8,  scale: 2
    t.decimal  "width",                 precision: 8,  scale: 2
    t.decimal  "depth",                 precision: 8,  scale: 2
    t.datetime "deleted_at"
    t.boolean  "is_master",                                      default: false
    t.integer  "product_id"
    t.decimal  "cost_price",            precision: 10, scale: 2
    t.integer  "position"
    t.string   "cost_currency"
    t.boolean  "track_inventory",                                default: true
    t.integer  "tax_category_id"
    t.datetime "updated_at"
    t.integer  "stock_items_count",                              default: 0,     null: false
    t.integer  "maturity",                                       default: 0
    t.integer  "bed_type",                                       default: 0
    t.string   "departure_city"
    t.string   "sumcode"
    t.string   "item_code"
    t.string   "description"
    t.string   "room_type"
    t.string   "supplier_product_code",                          default: ""
    t.boolean  "miscellaneous_charges",                          default: false
    t.string   "package_option"
    t.string   "accommodation"
    t.datetime "departure_date"
    t.boolean  "featured",                                       default: false
  end

  add_index "spree_variants", ["deleted_at"], name: "index_spree_variants_on_deleted_at", using: :btree
  add_index "spree_variants", ["is_master"], name: "index_spree_variants_on_is_master", using: :btree
  add_index "spree_variants", ["position"], name: "index_spree_variants_on_position", using: :btree
  add_index "spree_variants", ["product_id", "maturity", "bed_type", "departure_city"], name: "index_variants_on_product_maturity_bed_type_departure_city", using: :btree
  add_index "spree_variants", ["product_id"], name: "index_spree_variants_on_product_id", using: :btree
  add_index "spree_variants", ["tax_category_id"], name: "index_spree_variants_on_tax_category_id", using: :btree
  add_index "spree_variants", ["track_inventory"], name: "index_spree_variants_on_track_inventory", using: :btree

  create_table "spree_zone_members", force: true do |t|
    t.integer  "zoneable_id"
    t.string   "zoneable_type"
    t.integer  "zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_zone_members", ["zone_id"], name: "index_spree_zone_members_on_zone_id", using: :btree
  add_index "spree_zone_members", ["zoneable_id", "zoneable_type"], name: "index_spree_zone_members_on_zoneable_id_and_zoneable_type", using: :btree

  create_table "spree_zones", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "default_tax",        default: false
    t.integer  "zone_members_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_zones", ["default_tax"], name: "index_spree_zones_on_default_tax", using: :btree

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

  create_table "stickers", force: true do |t|
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.text     "focus_keyword"
    t.text     "seo_title"
    t.text     "meta_description"
    t.string   "hero_image"
    t.boolean  "featured",            default: false
    t.integer  "author_id"
    t.integer  "story_type_id"
    t.text     "excerpt",             default: ""
    t.string   "canonical_url",       default: ""
  end

  add_index "stories", ["primary_category_id"], name: "index_stories_on_primary_category_id", using: :btree
  add_index "stories", ["slug"], name: "index_stories_on_slug", using: :btree
  add_index "stories", ["story_type_id"], name: "index_stories_on_story_type_id", using: :btree
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

  create_table "story_types", force: true do |t|
    t.string   "name",       default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "status"
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

  create_table "tab_infos", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.integer  "tab_infoable_id"
    t.string   "tab_infoable_type"
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
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
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
    t.boolean  "is_private",                        default: true
    t.text     "description"
    t.string   "gender"
    t.string   "mobile"
    t.string   "home_phone"
    t.boolean  "created_from_ax",                   default: false
    t.string   "ax_cust_account"
    t.string   "spree_api_key",          limit: 48
    t.integer  "ship_address_id"
    t.integer  "bill_address_id"
    t.boolean  "guest",                             default: false
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
