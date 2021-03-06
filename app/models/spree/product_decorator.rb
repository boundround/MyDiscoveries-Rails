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
               :number_of_days,
               :number_of_nights,
               :inclusions,
               :places_visited,
               :subcategory

    attribute :display_name do
      name
    end

    attribute :where_destinations do
      'Offers'
    end

    attribute :result_type do
      "Offer"
    end

    attribute :result_icon do
      "tags"
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

    attribute :number_of_days do
      number_of_days
    end

    attribute :number_of_nights do
      number_of_nights
    end

    attribute :endDate do
      publishenddate
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

    attribute :item_id do
      item_id
    end

    attribute :child_item_id do
      child_item_id
    end

    attribute :related_item_id do
      related_products.map do |r|
        {
          id:            (r.spree_related_product_id if r.spree_related_product_id),
          item_id:       (r.related_product.item_id if r.related_product),
          child_item_id: (r.related_product.child_item_id if r.related_product)
        }
      end
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
      'publish_date',
      'tags',
      'item_id',
      'child_item_id',
      'related_item_id',
      'tags',
      'places_visited'
    ]

    # the `customRanking` setting defines the ranking criteria use to compare two matching
    # records in case their text-relevance is equal. It should reflect your record popularity.
    customRanking Searchable.custom_ranking

    attributesForFaceting [
      'where_destinations',
      'result_type',
      'result_icon',
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
      'places_visited'
    ]

    add_index "mydiscoveries_offers_#{Rails.env}", id: :algolia_id, if: :published? do
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
                 :number_of_days,
                 :number_of_nights,
                 :endDate,
                 :inclusions,
                 :places_visited,
                 :subcategory

      attribute :display_name do
        name
      end

      attribute :where_destinations do
        'Offers'
      end

      attribute :result_type do
        "Offer"
      end

      attribute :result_icon do
        "tags"
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

      attribute :item_id do
        item_id
      end

      attribute :child_item_id do
        child_item_id
      end

      attribute :related_item_id do
        related_products.map do |r|
          {
            id:            (r.spree_related_product_id if r.spree_related_product_id),
            item_id:       (r.related_product.item_id if r.related_product),
            child_item_id: (r.related_product.child_item_id if r.related_product)
          }
        end
      end

      attribute :inclusions do
        inclusions.map(&:name)
      end

      attribute :startDate do
        startDate
      end

      attribute :endDate do
        publishenddate
      end

      attribute :number_of_days do
        number_of_days
      end

      attribute :number_of_nights do
        number_of_nights
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
        'tags',
        'accessible',
        'subcategories',
        'places',
        'attractions',
        'countries',
        'regions',
        'publish_date',
        'item_id',
        'child_item_id',
        'related_item_id'
      ]

      # the `customRanking` setting defines the ranking criteria use to compare two matching
      # records in case their text-relevance is equal. It should reflect your record popularity.
      customRanking Searchable.custom_ranking

      attributesForFaceting [
        'where_destinations',
        'result_type',
        'result_icon',
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
        'places_visited'
      ]
    end

  end

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  acts_as_taggable_on :inclusions

  scope :active, -> { where("status = ?", "live") }
  scope :featured, -> { where("featured = ?", true) }
  scope :prioritized, -> { reorder(priority: :asc) }
  scope :publishing_queue, -> { where("publishstartdate = ?", (Time.now - 10.hours)) }
  scope :expiring_queue, -> { where("publishenddate_active = ?", true).where("publishenddate = ?", (Time.now - 10.hours)) }

  belongs_to :attraction
  belongs_to :operator
  belongs_to :place

  has_many :products_photos, dependent: :destroy
  has_many :photos, through: :products_photos

  # has_many :photos, -> { order "created_at ASC"}, as: :photoable
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

  has_many :products_stickers
  has_many :stickers, through: :products_stickers

  has_many :orders

  has_many :related_products

  serialize :departure_dates

  validates_presence_of :operator, unless: -> { livn_product_id? }
  validates_presence_of :startDate, :endDate, unless: -> { livn_product_id? }
  validate :at_least_one_options_allowed

  # override default spree validations
  _validators.reject!{ |key, value| key == :shipping_category_id }
  _validate_callbacks.each do |callback|
    callback.raw_filter.attributes.reject! { |key| key == :shipping_category_id } if callback.raw_filter.respond_to?(:attributes)
  end

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :stickers, allow_destroy: true

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

  def minRateAdult
    prices = []
    variants.each do |variant|
      if variant.featured?
        return variant.price.to_f
      end
      if variant.maturity.present? && variant.maturity.downcase.strip != "child"
        prices << variant.price.to_f
      end
    end
    prices.min
  end

  def published?
    self.status == "live"
  end

  def slug_candidates
    if status == 'live'
      :name
    else
      [[:name, :status]]
    end
  end

  def self.featured_products
    products = self.active.where(featured: true)

    if products.blank?
      products = Spree::Product.active.limit(4)
    end

    products
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed? || status_changed?
  end

  def directions
    (locationEnd.present? && locationStart != locationEnd) ? "#{locationStart} - #{locationEnd}" : locationStart
  end

  def all_options_disabled?
    disable_maturity?       &&
    disable_bed_type?       &&
    disable_room_type?      &&
    disable_package_option? &&
    disable_accommodation?  &&
    disable_departure_date? &&
    disable_departure_city?
  end

  def sna_product_with_date
    operator_id == 1 && disable_departure_date == false
  end

  def variants_table
    all_variants.uniq.map do |item|
      item.select { |k, _| item[k].present? }
    end
  end

  def variants_table_keys
    replacements = {
      maturity: 'Adult / Child',
      bed_type: 'Twin / Single',
      room_type: room_type_label.present? ? room_type_label : 'Room Type',
      package_option: package_option_label.present? ? package_option_label : 'Package Option',
      accommodation: 'Accommodation',
      departure_city: 'Departure City'
    }
    variants_table.
      first.
      keys.
      reject { |el| el == :price }.
      map { |el| replacements.fetch(el, el) }
  end

  def all_variants
    variants.map { |variant| variant_data(variant) }
  end

  def variant_data(variant)
    columns = %i(maturity bed_type room_type package_option accommodation departure_city)
    default_data = columns.each_with_object({}) do |el, h|
      h[el] = variant.send(el) unless send("disable_#{el}")
      if respond_to?("#{el}_label".to_sym) && send("#{el}_label").present?
        h[send("#{el}_label")] = h.delete(el)
      end
      h['Twin / Single'] = h.delete(el) if el == :bed_type
    end

    default_data.merge(price: variant.price.to_s)
  end

  private

  def at_least_one_options_allowed
    if all_options_disabled?
      errors.add(:base, 'At least one variant option must be allowed')
    end
  end

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
