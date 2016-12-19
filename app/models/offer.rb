class Offer < ActiveRecord::Base
  include AlgoliaSearch
  include Searchable
  include SearchOptimizable
  include Observers::Offer

  alias_attribute :minimum_age, :minAge
  alias_attribute :maximum_age, :maxAge

  algoliasearch index_name: "place_#{Rails.env}", id: :algolia_id do

    attributes :minAge,
               :maxAge,
               :minRateAdult,
               :minRateChild,
               :minRateInfant,
               :minUnits,
               :maxUnits,
               :duration,
               :page_ranking_weight,
               :age_range,
               :weather,
               :price,
               :best_time_to_visit,
               :subcategories,
               :accessibility,
               :hero_photo,
               :accessible

    attribute :display_name do
      name
    end

    attribute :where_destinations do
      'Offers'
    end

    attribute :countries do
      countries.map { |country| country.display_name }
    end

    attribute :places do
      places.map { |place| { name: place.display_name, identifier: place.identifier } }
    end

    attribute :regions do
      regions.map { |region| region.display_name }
    end

    attribute :attractions do
      attractions.map { |attraction| { name: attraction.display_name, identifier: attraction.identifier } }
    end

    attribute :photos do
      photo_array = photos.select { |photo| photo.published? }.map do |photo|
        { url: photo.path_url(:small), alt_tag: photo.alt_tag }
      end
      photo_array
    end

    attribute :has_hero_image do
      photos.exists?(hero: true)
    end

    attribute :subcategories do
      subcategories.map { |sub| { name: sub.name, identifier: sub.identifier } }
    end

    attribute :description do
      description.blank? ? "" : description
    end

    attribute :is_country do
      false
    end

    attribute :is_area do
      false
    end

    attribute :is_offer do
      true
    end

    attributesToIndex [
      'display_name',
      'unordered(description)',
      'age_range',
      'accessible',
      'subcategories',
      'places',
      'attractions',
      'countries',
      'regions',
      'publish_date'
    ]

    # the `customRanking` setting defines the ranking criteria use to compare two matching
    # records in case their text-relevance is equal. It should reflect your record popularity.
    customRanking Searchable.custom_ranking

    attributesForFaceting [
      'where_destinations',
      'is_offer',
      'age_range',
      'subcategory',
      'weather',
      'price',
      'best_time_to_visit',
      'accessibility',
      'minAge',
      'maxAge',
      'minRateAdult',
      'minRateChild',
      'minRateInfant',
      'duration',
      'minUnits',
      'maxUnits'
    ]

  end

  belongs_to :attraction

  has_many :offers_photos, dependent: :destroy
  has_many :photos, through: :offers_photos

  has_many :offers_videos, dependent: :destroy
  has_many :videos, through: :offers_videos

  has_many :offers_attractions, dependent: :destroy
  has_many :attractions, through: :offers_attractions

  has_many :offers_places, dependent: :destroy
  has_many :places, through: :offers_places

  has_many :offers_countries, dependent: :destroy
  has_many :countries, through: :offers_countries

  has_many :offers_regions
  has_many :regions, through: :offers_regions

  has_many :offers_subcategories, dependent: :destroy
  has_many :subcategories, through: :offers_subcategories

  has_many :orders

  validates_presence_of :name
  validates_presence_of :startDate, :endDate, unless: -> { livn_product_id? }
  validates :startDate, :endDate, absence: true, if: -> { livn_product_id? }

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true

  def publish_date
    update_at
  end

  def shopify_product
    ShopifyAPI::Product.find(shopify_product_id) if shopify_product_id?
  end

  private

  def hero_photo
    hero_h = photos.where(photos: { hero: true })
    hero_h = hero_h.first
    hero = {}
    if hero_h.present?
      hero= { url: hero_h.path_url(:medium), alt_tag: hero_h.caption }
    else
      hero = { url: ActionController::Base.helpers.asset_path('generic-hero.jpg'), alt_tag: "Activity Collage"}
    end
    hero
  end

  def algolia_id
    "offer_#{id}"
  end
end