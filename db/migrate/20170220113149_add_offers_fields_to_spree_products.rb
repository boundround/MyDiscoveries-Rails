class AddOffersFieldsToSpreeProducts < ActiveRecord::Migration
  def change
    change_table "spree_products" do |t|
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
      t.string   "places_visited",                                                default: [],    array: true
      t.integer  "number_of_days"
      t.integer  "number_of_nights"
      t.string   "itinerary"
    end

    add_index "spree_products", "attraction_id"
    add_index "spree_products", "place_id"
    add_index "spree_products", "shopify_product_id"
  end
end
