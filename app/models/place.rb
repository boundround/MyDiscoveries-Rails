class Place < ActiveRecord::Base
  include CustomerApprovable
  include AlgoliaSearch
  include Searchable
  include SearchOptimizable
  include Reviewable

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :run_rake, :no_parent_select

  algoliasearch index_name: "mydiscoveries_#{Rails.env}", id: :algolia_id, if: :published? do
    # list of attribute used to build an Algolia record
    attributes :display_name,
               :status,
               :latitude,
               :longitude,
               :locality,
               :post_code,
               :display_address,
               :identifier,
               :slug,
               :minimum_age,
               :maximum_age,
               :viator_link,
               :primary_category_priority,
               :is_area,
               :page_ranking_weight,
               :age_range,
               :weather,
               :price,
               :best_time_to_visit,
               :subcategories,
               :accessibility,
               :hero_photo,
               :accessible,
               :main_category,
               :subcategory

    synonyms [
        ["active", "water sports", "sports", "sport", "watersports"],
        ["disabled", "wheelchair access", "accessible"],
        ["culture", "cultural", "museum", "indigenous", "gallery", "galleries", "museums", "historic", "history"],
        ["science", "technology"],
        ["things to do", "something to do", "stuff to do", "activity", "activities"],
        ["year old", "ages", "year"],
        ["6", "7", "5-8"],
        ["10", "11", "9-12"],
        ["teenager", "teens", "teenagers"]
      ]

    attribute :country do
      if self.country
        "#{country.display_name}"
      else
        ""
      end
    end

    attribute :where_destinations do
      'Places' if self.class.to_s == 'Place'
    end

    attribute :url do
      Rails.application.routes.url_helpers.place_path(self)
    end

    attribute :description do
      description.blank? ? "" : description
    end

    attribute :primary_category do
       if self.primary_category
        { name: "#{primary_category.name}", identifier: primary_category.identifier}
      else
        ""
      end
    end

    attribute :result_type do
      if self.is_area == true
        "Destination"
      else
        if self.primary_category.blank?
          "Something To Do"
        else
          self.primary_category.name
        end
      end
    end

    attribute :result_icon do
      "map-marker"
    end

    attribute :name do
      string = "#{display_name}"
      if !locality.blank?
        string += ", #{locality}"
      end
      if country
        string += ", #{self.country.display_name}"
      end
      string
    end

    attribute :photos do
      photo_array = photos.select { |photo| photo.published? }.map do |photo|
        { url: photo.path_url(:small), alt_tag: photo.alt_tag }
      end
      photo_array += user_photos.select { |photo| photo.published? }.map do |photo|
        { url: photo.path_url(:small), alt_tag: photo.caption }
      end
      photo_array
    end

    attribute :has_hero_image do
      photos.exists?(hero: true) || user_photos.exists?(hero: true)
    end

    attribute :weather do
      subcategories.where(category_type: 'weather').map{ |sub|  sub.name }
    end

    attribute :price do
      subcategories.where(category_type: 'price').map{ |sub|  sub.name }
    end

    attribute :best_time_to_visit do
      subcategories.where(category_type: 'optimum_time').map{ |sub|  sub.name }
    end

    attribute :accessibility do
      subcategories.where(category_type: 'accessibility').map{ |sub|  sub.name }
    end

    attribute :subcategories do
      subcategories.map { |sub| { name: sub.name, identifier: sub.identifier } }
    end

    attribute :parents do
      self.get_parents(self).map {|place| place.display_name rescue ''}
    end

    attribute :display_address do
      dp_add = self.display_address
      unless dp_add.blank?
        dp_add.split(', ').last(2).join(', ')
      end
    end

     #country and url

    # the attributesToIndex` setting defines the attributes
    # you want to search in: here `title`, `subtitle` & `description`.
    # You need to list them by order of importance. `description` is tagged as
    # `unordered` to avoid taking the position of a match into account in that attribute.
    attributesToIndex [
      'display_name',
      'unordered(description)',
      'tags',
      'age_range',
      'accessible',
      'subcategories',
      'unordered(parents)',
      'unordered(display_address)',
      'unordered(primary_category)',
      'publish_date',
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
      'is_area',
      'main_category',
      'subcategory',
      'weather',
      'price',
      'best_time_to_visit',
      'accessibility',
      'places_visited'
    ]
  end

  # ratyrate_rateable "quality"
  before_save :set_country

  has_many :rates_without_dimension, -> { where dimension: nil}, as: :rateable, class_name: 'Rate', dependent: :destroy
  has_many :raters_without_dimension, through: :rates_without_dimension, source: :rater

  has_one :rate_average_without_dimension, -> { where dimension: nil}, as: :cacheable,
          class_name: 'RatingCache', dependent: :destroy

  has_many :offers_places, dependent: :destroy
  has_many :offers, through: :offers_places

  has_many :products_places, class_name: Spree::ProductsPlace, dependent: :destroy
  has_many :products, through: :products_places, class_name: Spree::Product

  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode

  has_paper_trail

  resourcify

  extend FriendlyId
  friendly_id :slug_candidates, :use => [:slugged, :history] #show display_names in place routes

  scope :active, -> { where(status: "live") }
  scope :not_removed, -> { where('status != ?', 'removed') }
  scope :preview, -> { where('status=? OR status=?', 'live', 'edited') }

  scope :publishing_queue, -> { where('published_at <= ?', Time.now) }
  scope :removal_queue, -> { where('unpublished_at <= ?', Time.now) }

  scope :to_be_published, -> { where('published_at >= ?', Time.now) }
  scope :to_be_removed, -> { where('unpublished_at >= ?', Time.now) }
  scope :is_area, -> {where(is_area: true)}
  scope :is_not_area, -> {where(is_area: nil)}
  scope :live_places_with_photos, -> { includes(:photos).where(status: "live")}

  validates_presence_of :display_name


  belongs_to :country, :class_name => "Place"
  belongs_to :user
  belongs_to :primary_category

  has_one :parent, :class_name => "ChildItem", as: :itemable
  has_many :childrens, :class_name => "ChildItem", as: :parentable

  has_many :places_subcategories
  has_many :discounts
  has_many :similar_places
  has_many :associated_areas, through: :similar_places, source: :similar_place
  has_many :subcategories, through: :places_subcategories
  has_many :photos, -> { order "created_at ASC"}, as: :photoable
  has_many :videos, -> { order "created_at ASC"}, as: :videoable
  has_many :fun_facts, -> { order "created_at ASC"}, as: :fun_factable
  has_many :programs, -> { order "created_at ASC"}
  has_many :user_photos

  has_many :good_to_knows, as: :good_to_knowable
  has_many :tab_infos, as: :tab_infoable

  has_many :places_users
  has_many :users, through: :places_users

  has_many :places_posts
  has_many :posts, through: :places_posts

  has_many :places_stories
  has_many :stories, through: :places_stories

  has_many :reviews, as: :reviewable
  has_many :deals, as: :dealable

  has_many :three_d_videos, as: :three_d_videoable

  has_many :stamps

  has_and_belongs_to_many :regions

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :fun_facts, allow_destroy: true
  accepts_nested_attributes_for :programs, allow_destroy: true
  accepts_nested_attributes_for :reviews, allow_destroy: true
  accepts_nested_attributes_for :stories, allow_destroy: true
  accepts_nested_attributes_for :user_photos, allow_destroy: true
  accepts_nested_attributes_for :three_d_videos, allow_destroy: true
  accepts_nested_attributes_for :stamps, allow_destroy: true
  accepts_nested_attributes_for :parent, :allow_destroy => true

  after_update :flush_place_cache # May be able to be removed
  # after_update :flush_places_geojson

  def published?
    if self.status == "live"
      true
    else
      false
    end
  end

  def publish_date
    update_at
  end

  def place_sub_subcategory
    self.places_subcategories.select { |s| true }.map do |s|
      { name: s.subcategory.name, attr: s.subcategory.name }
    end
  end

  def self.return_first_place_id_from_search_results(search_response, region)
    id = nil
    search_response["hits"].each do |hit|
      if (hit["objectID"].include?("place")) && (hit["is_area"] == false) && (hit["parents"].any? { |x| x.downcase.include? region } )
        id = hit["objectID"].gsub("place_", "").to_i
        break
      end
    end
    id
  end

  def flush_place_cache
    Rails.cache.delete('all_places')
  end

  def Place.all_places
    Rails.cache.fetch("all_places") { Place.select(:id, :display_name, :bound_round_place_id) }
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    Place.create!(row.to_h)
    end
  end

  def self.import_update(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      place = Place.find row["id"]
      place.update!(row.to_h)
    end
  end

  def self.import_subcategories(file)
    places_subcategory = nil
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      row = row.to_h
      row.each do |key, value|
        if key != "id"
          if value == 1
            places_subcategory = PlacesSubcategory.find_or_create_by(place_id: row["id"], subcategory_id: key)
          end
        end
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then CSV.new(file.path)
    when '.xls' then Roo::Spreadsheet.open(file.path, extension: :xls)
    when '.xlsx' then Roo::Spreadsheet.open(file.path, extension: :xlsx)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def load_into_soulmate
    if self.status == "live"
      loader = Soulmate::Loader.new("place")
      loader.add("term" => display_name.downcase + ' ' + (description ? description.downcase : ""),
                "display_name" => display_name, "id" => id, "latitude" => latitude, "longitude" => longitude,
                "url" => '/places/' + slug + '.html', "slug" => slug, "placeType" => "place",
                "area" => {"display_name" => (self.locality ? self.locality : ""), "country" => (self.country ? self.country.display_name : "") })
    else
      self.remove_from_soulmate
    end
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("place")
    loader.remove("id" => self.id)
  end

  def slug_candidates
    if status == 'live'
      :display_name
    else
      [[:display_name, :status]]
    end
  end

  def get_parents(place, parents = [])
    if place.parent.blank? || place.parent.parentable == self
      return parents
    elsif place.parent.parentable.blank?
      return parents
    elsif place.parent.parentable == place
      return parents
    else
      parents << place.parent.parentable
      get_parents(place.parent.parentable, parents)
    end
  end

  def set_country
    if self.is_country
      self.country_id = self.id
    end
    country = get_parents(self).find {|parent| parent.class.to_s == "Place" && parent.is_country }
    if country
      self.country_id = country.id
    end
  end

  def places_to_visits
    places_to_visit = self.children
    places_to_visit = places_to_visit.sort do |x, y|
      y.videos.size <=> x.videos.size
    end
  end

  def place_stories
    stories = self.posts.active
    stories += self.stories.active
    stories = stories.sort{|x, y| x.publish_date <=> y.publish_date}
  end

  def active_user_photos
    photos = self.photos.active.sort {|x, y| x.created_at <=> y.created_at}

    return photos
  end

  def publish
    self.status = "live"
    self.published_at = nil
    self.save
  end

  def unpublish
    self.status = "removed"
    self.unpublished_at = nil
    self.save
  end

  def markers
    marker = []
    self.products.each do |offer|
      marker << offer.attraction
    end
    return marker
  end

  def crop_hero_image
    hero_image.recreate_versions! if crop_x.present?
  end

  def create_bound_round_id

    self.bound_round_place_id = SecureRandom.urlsafe_base64
    self.save
  end

  def fix_australian_states
    if self.state
      case self.state.downcase
      when "new south wales"
        self.state = "NSW"
      when "queensland"
        self.state = "QLD"
      when "victoria"
        self.state = "VIC"
      when "south australia"
        self.state = "SA"
      when "western australia"
        self.state = "WA"
      when "northern territory"
        self.state = "NT"
      when "australian capital territory"
        self.state = "ACT"
      when "tasmania"
        self.state = "TAS"
      end
    end
  end

  def country_code
    if country
      country_name = ISO3166::Country.find_country_by_name(country.display_name)
      return country_name.alpha2.downcase
    else
      ""
    end
  end

  def should_generate_new_friendly_id?
    slug.blank? || display_name_changed? || status_changed?
  end

  def trip_advisor_info
    body = nil
    trip_advisor_id = nil
    if trip_advisor_url.present?
      trip_advisor_id = trip_advisor_url.match(/(.*)(d[0-9]+)(.*)/)[2].gsub("d", "") if trip_advisor_url.match(/(.*)(d[0-9]+)(.*)/)
    end
    if trip_advisor_id
      response = HTTParty.get("http://api.tripadvisor.com/api/partner/2.0/location/#{trip_advisor_id}?key=6cd1112100c1424a9368e441f50cb642")
    else
      response = nil
    end

    if response.present?
      body = JSON.parse(response.body)
    end

    body
  end

  def content
    description
  end

  def short_description
    meta_description
  end

  def children
    list = childrens.select {|child| child.itemable.present?}
    list = list.map { |child| child.itemable }
  end

  def country_extra_data
    if self.country
      iso_country = ISO3166::Country.find_country_by_name(self.country.display_name)
      if iso_country.present?
        country_languages = iso_country.languages
        country_currency = iso_country.currency.code
        languages = country_languages.collect{|l| ISO_639.find(l).english_name }
        return country_currency, languages
      end
    end
  end

  private

  def hero_photo
    hero_h = photos.where(photos: { hero: true })
    hero_h += user_photos.where(user_photos: { hero: true })
    hero_h = hero_h.first
    hero = {}
    if hero_h.present?
      hero= { url: hero_h.path_url(:small), alt_tag: hero_h.caption }
    else
      hero = { url: ActionController::Base.helpers.asset_path('generic-hero.jpg'), alt_tag: "Activity Collage"}
    end
    hero
  end

  def algolia_id
    "place_#{id}" # ensure the place & country IDs are not conflicting
  end


  class << self
    def filter params= {}
      res= self.all
      if params.present?
        if params[:min_age]
          res= res.where(" places.minimum_age >= ?", params[:min_age])
        end
        if params[:max_age]
          res= res.where(" places.maximum_age <= ?", params[:max_age])
        end
      end
      res
    end
  end

end
