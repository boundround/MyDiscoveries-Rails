Spree::Product.class_eval do
  include AlgoliaSearch
  include Searchable
  include SearchOptimizable
  include Observers::Product
  include Reviewable

  alias_attribute :minimum_age, :minAge
  alias_attribute :maximum_age, :maxAge

  algoliasearch index_name: "mydiscoveries_#{Rails.env}", id: :algolia_id, if: :published? do

    attributes :minAge,
               :maxAge,
               :minRateAdult,
               :minRateChild,
               :minRateInfant,
               :minUnits,
               :maxUnits,
               :duration,
               :page_ranking_weight,
               :weather,
               :price,
               :best_time_to_visit,
               :subcategories,
               :accessibility,
               :hero_photo,
               :accessible,
               :tags,
               :startDate,
               :endDate,
               :inclusions,
               :places_visited

    attribute :display_name do
      name
    end

    attribute :where_destinations do
      'Offers'
    end

    attribute :url do
      Rails.application.routes.url_helpers.offer_path(self)
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

    attribute :startDate do
      startDate
    end

    attribute :endDate do
      endDate
    end

    attribute :photos do
      photo_array = photos.select { |photo| photo.published? }.map do |photo|
        { url: photo.path_url(:small), alt_tag: photo.alt_tag, caption: photo.caption }
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

    attribute :inclusions do
      inclusions.map(&:name)
    end

    attribute :places_visited do
      places_visited
    end

    attribute :tags do
      tags.blank? ? [] : tags[0..1]
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
      'subcategory',
      'weather',
      'price',
      'best_time_to_visit',
      'accessibility',
      'minRateAdult',
      'minRateChild',
      'minRateInfant',
      'duration',
      'minUnits',
      'maxUnits',
      'tags',
      'places_visited'
    ]

    add_index "mydiscoveries_offers_#{Rails.env}", if: :published? do
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
                 :accessible,
                 :tags,
                 :startDate,
                 :endDate,
                 :inclusions,
                 :places_visited

      attribute :display_name do
        name
      end

      attribute :where_destinations do
        'Offers'
      end

      attribute :url do
        Rails.application.routes.url_helpers.offer_path(self)
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
          { url: photo.path_url(:small), alt_tag: photo.alt_tag, caption: photo.caption }
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

      attribute :places_visited do
        places_visited
      end

      attribute :tags do
        tags.blank? ? [] : tags[0..1]
      end

      attribute :inclusions do
        inclusions.map(&:name)
      end

      attribute :startDate do
        startDate
      end

      attribute :endDate do
        endDate
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
        'minRateAdult',
        'minRateChild',
        'minRateInfant',
        'duration',
        'minUnits',
        'maxUnits',
        'tags',
        'places_visited'
      ]
    end

  end

  friendly_id :slug_candidates, use: [:slugged, :history]

  acts_as_taggable_on :inclusions

  scope :active, -> { where("status = ? OR (publishstartdate <= ? AND publishenddate >= ?)", "live", Date.today, Date.today) }

  belongs_to :attraction
  belongs_to :operator
  belongs_to :place

  # has_many :products_photos, dependent: :destroy
  # has_many :photos, through: :products_photos

  has_many :photos, -> { order "created_at ASC"}, as: :photoable
  has_many :videos, -> { order "created_at ASC"}, as: :videoable

  has_many :products_attractions, dependent: :destroy
  has_many :attractions, through: :products_attractions

  has_many :products_places, dependent: :destroy
  has_many :places, through: :products_places

  has_many :products_countries, dependent: :destroy
  has_many :countries, through: :products_countries

  has_many :products_regions
  has_many :regions, through: :products_regions

  has_many :products_subcategories, dependent: :destroy
  has_many :subcategories, through: :products_subcategories

  has_many :products_users
  has_many :users, through: :products_users

  has_many :orders

  has_many :related_products

  validates_presence_of :operator, unless: -> { livn_product_id? }
  validates_presence_of :startDate, :endDate, unless: -> { livn_product_id? }

  # override default spree validations
  _validators.reject!{ |key, value| key == :shipping_category_id }
  _validate_callbacks.each do |callback|
    callback.raw_filter.attributes.reject! { |key| key == :shipping_category_id } if callback.raw_filter.respond_to?(:attributes)
  end

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true

  mount_uploader :itinerary, ProductItineraryUploader

  def publish_date
    update_at
  end

  def display_name
    if self.attribute_names.include? 'display_name'
      display_name
    else
      name
    end
  end

  def published?
    if self.status == "live"
      true
    else
      false
    end
  end

  def slug_candidates
    :name
  end

  def self.featured_products
    products = self.active.where(featured: true)

    if products.blank?
      products = active.limit(4)
    end

    products
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def directions
    (locationEnd.present? && locationStart != locationEnd) ? "#{locationStart} - #{locationEnd}" : locationStart
  end

  private

  def hero_photo
    hero_h = photos.where(photos: { hero: true })
    hero_h = hero_h.first
    hero = {}
    if hero_h.present?
      hero = { url: hero_h.path_url(:medium), alt_tag: hero_h.caption }
    else
      hero = { url: ActionController::Base.helpers.asset_path('generic-hero.jpg'), alt_tag: "Activity Collage"}
    end
    hero
  end

  def algolia_id
    "product_#{id}"
  end

end
