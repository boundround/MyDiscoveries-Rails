class CreateAttractions < ActiveRecord::Migration
  def change
    create_table :attractions do |t|
      t.text     :description
      t.string   :code
      t.string   :identifier
      t.string   :display_name
      t.string   :subscription_level
      t.string   :icon
      t.string   :map_icon
      t.string   :passport_icon
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :slug
      t.float    :latitude
      t.float    :longitude
      t.string   :address
      t.text     :opening_hours
      t.string   :phone_number
      t.string   :website
      t.string   :logo
      t.string   :url
      t.string   :display_address
      t.string   :booking_url
      t.string   :post_code
      t.string   :street_number
      t.string   :route
      t.string   :sublocality
      t.string   :locality
      t.string   :state
      t.string   :place_id
      t.string   :status
      t.datetime :published_at
      t.datetime :unpublished_at
      t.boolean  :user_created
      t.string   :created_by
      t.boolean  :customer_review
      t.boolean  :customer_approved
      t.datetime :approved_at
      t.boolean  :show_on_school_safari,     default: false
      t.text     :school_safari_description
      t.string   :hero_image
      t.string   :bound_round_place_id
      t.boolean  :is_area,                   default: false
      t.text     :short_description
      t.string   :weather_conditions
      t.integer  :minimum_age
      t.integer  :maximum_age
      t.text     :special_requirements
      t.boolean  :top_100,                   default: false
      t.text     :viator_link,               default: ""
      t.boolean  :footer_include
      t.boolean  :primary_area
      t.string   :algolia_id
      t.string   :email
      t.integer  :parent_id
      t.string   :trip_advisor_url
      t.decimal  :page_ranking_weight
      t.integer  :algolia_clicks,            default: 0
      t.integer  :area_id
      t.references :country, index: true
      t.references :user, index: true
      t.references :primary_category, index: true

      t.timestamps
    end
  end
end
