class Place < ActiveRecord::Base
  include CustomerApprovable
  include AlgoliaSearch
  include Searchable

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :run_rake

  algoliasearch index_name: "place_#{Rails.env}", id: :algolia_id, if: :published? do
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
               :page_ranking_weight

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

    attribute :is_country do
      false
    end

    attribute :result_icon do
      "map-marker"
    end

    attribute :main_category do
      primary_category.name if primary_category.present?
    end

    attribute :subcategories do
      subcategories.map{ |sub| { name: sub.name, identifier: sub.identifier } }
    end

    attribute :subcategory do
      subcategories.subcats.map{|sub| sub.name}
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

    attribute :hero_photo do
      hero_h = photos.where(photos: { hero: true })
      hero_h += user_photos.where(user_photos: { hero: true })
      hero_h = hero_h.first
      hero= {}
      if hero_h.present?
        hero= { url: hero_h.path_url(:small), alt_tag: hero_h.caption }
      else
        hero = { url: ActionController::Base.helpers.asset_path('generic-hero.jpg'), alt_tag: "Activity Collage"}
      end
      hero
    end

    attribute :has_hero_image do
      photos.exists?(hero: true) || user_photos.exists?(hero: true)
    end

    attribute :age_range do
      if minimum_age.present? and maximum_age.present?
        if minimum_age > 12
          ["Teens"]
        elsif minimum_age > 8 && maximum_age < 13
          ["For Ages 9-12"]
        elsif minimum_age > 8
          ["For Ages 9-12", "Teens"]
        elsif maximum_age < 13
          ["For Ages 5-8", "For Ages 9-12"]
        elsif maximum_age < 9
          ["For Ages 5-8"]
        else
          ["For Ages 5-8", "For Ages 9-12", "Teens", "All Ages"]
        end
      else
        ["For Ages 5-8", "For Ages 9-12", "Teens", "All Ages"]
      end

        # if ((5..8).include?(minimum_age) and (5..8).include?(maximum_age)) or ((9..12).include?(minimum_age) and (9..12).include?(maximum_age) )
        #   "For Ages #{minimum_age}-#{maximum_age}"
        # else
        #   'Teens'
        # end
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

    attribute :parents do
      self.get_parents(self).map {|place| place.display_name rescue ''} unless !self.run_rake.blank?
    end

    attribute :accessible do
      if subcategories.any? { |sub| sub.category_type == "accessibility" }
        "accessible"
      else
        ""
      end
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
      'age_range',
      'accessible',
      'subcategories',
      'unordered(parents)',
      'unordered(display_address)',
      'unordered(primary_category)',
      'publish_date',
    ]

    # the `customRanking` setting defines the ranking criteria use to compare two matching
    # records in case their text-relevance is equal. It should reflect your record popularity.
    customRanking [
      'desc(is_country)',
      'desc(is_area)',
      'desc(primary_category_priority)',
      'desc(page_ranking_weight)',
      'desc(has_hero_image)',
    ]

    attributesForFaceting [
      'where_destinations',
      'is_area',
      'main_category',
      'age_range',
      'subcategory',
      'weather',
      'price',
      'best_time_to_visit',
      'accessibility'
    ]
  end

  # ratyrate_rateable "quality"

  has_many :rates_without_dimension, -> { where dimension: nil}, as: :rateable, class_name: 'Rate', dependent: :destroy
  has_many :raters_without_dimension, through: :rates_without_dimension, source: :rater

  has_one :rate_average_without_dimension, -> { where dimension: nil}, as: :cacheable,
          class_name: 'RatingCache', dependent: :destroy

  has_many "quality_rates".to_sym, -> {where dimension: "quality"},
                                              dependent: :destroy,
                                              class_name: 'Rate',
                                              as: :rateable

  has_many "quality_raters".to_sym, through: "quality_rates".to_sym, source: :rater

  has_one "quality_average".to_sym, -> { where dimension: "quality" },
                                              as: :cacheable,
                                              class_name: 'RatingCache',
                                              dependent: :destroy

  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode

  after_update :crop_hero_image
  before_save :check_valid_url, :set_approval_time, :fix_australian_states, :autofill_short_description
  after_create :create_bound_round_id

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


  belongs_to :country
  belongs_to :user
  belongs_to :primary_category

  has_one :parent, :class_name => "ChildItem", as: :itemable
  has_many :childrens, :class_name => "ChildItem", as: :parentable

  has_many :places_subcategories
  has_many :similar_places
  has_many :associated_areas, through: :similar_places, source: :similar_place
  has_many :subcategories, through: :places_subcategories
  has_many :photos, -> { order "created_at ASC"}, as: :photoable
  has_many :videos, -> { order "created_at ASC"}, as: :videoable
  has_many :fun_facts, -> { order "created_at ASC"}
  has_many :programs, -> { order "created_at ASC"}
  has_many :user_photos

  has_many :good_to_knows, as: :good_to_knowable

  has_many :places_users
  has_many :users, through: :places_users

  has_many :places_posts
  has_many :posts, through: :places_posts

  has_many :places_stories
  has_many :stories, through: :places_stories

  has_many :customers_places
  has_many :owners, through: :customers_places, :source => :user

  has_many :reviews, as: :reviewable
  has_many :deals, as: :dealable

  has_many :three_d_videos, as: :three_d_videoable

  has_many :stamps

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
  after_create :update_parentable_id

  after_update :flush_place_cache # May be able to be removed
  after_update :flush_places_geojson

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

  def self.home_page_areas
    Rails.cache.fetch("home_page_areas", expires_in: 24.hours) do
      Place.active.is_area.where(primary_area: true).includes(:country, :photos).order("countries.display_name asc")
    end
  end

  # def self.text_search(query)
  #   if query.present?
  #     search(query)
  #   else
  #   # rescue ""
  #     scoped
  #   end
  # end
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

  def flush_places_geojson
    Rails.cache.delete('places_geojson')
  end

  def Place.all_placeareas_geojson
    # Fetch place GeoJSON from cache or store it in the cache.
#    Rails.cache.fetch('placeareas_geojson') do
      geojson = {"type" => "FeatureCollection","features" => []}
      places = self.active.includes(:country)
      places.each do |place|
        geojson['features'] << {
          type: 'Feature',
          geometry: {
            type: 'Point',
            coordinates: [place.longitude, place.latitude]
          },
          properties: {
            "title"=> place.display_name,
            "url" => '/places/' + place.slug + '.html',
            "id" => place.id,
            "places" => false,#area.places.all? { |place| place.status = "live" },
            "icon" => {
              "iconUrl" => 'https://s3-ap-southeast-2.amazonaws.com/brwebproduction/vector_icons/orange_plane.png',
              # size of the icon
              "iconSize" => [43, 26],
              # point of the icon which will correspond to marker location
              "iconAnchor" => [20, 0]
            },
            "placeCount" => 0,#area.places.length,
            "country" => (place.country ? place.country.display_name : "")
          }
        }
      end

      geojson
#    end
  end

  def Place.all_geojson
    # Fetch place GeoJSON from cache or store it in the cache.
    Rails.cache.fetch('places_geojson') do
      geojson = {"type" => "FeatureCollection","features" => [],"countries" => []}
      places = self.active.includes(:games, :videos, :photos, :country)
      places.each do |place|
        if place.area != nil
          area_info = {"title" => place.area.display_name, "url" => '/areas/' + place.area.slug + '.html', 'placeCount' => place.area.places.length, "country" => (place.country ? place.country.display_name : "") }
        end
        # Assign icon based on 'premium' level and category
        # if place.categories[0].nil?
        #   place_type = 'sights'
        # else
        #   place_type = place.categories[0].identifier
        # end

        icon_file_name = place_type + "_pin.png"

        geojson['features'] << {
          type: 'Feature',
          geometry: {
            type: 'Point',
            coordinates: [place.longitude, place.latitude]
          },
          properties: {
            "title"=> place.display_name,
            "id" => place.id,
            "category" => place_type,
            "url" => '/places/' + place.slug + '.html',

            "icon" => {

              "iconUrl" => "https://d1w99recw67lvf.cloudfront.net/category_icons/" + icon_file_name,

              # size of the icon
              "iconSize" => [20, 45],
              # point of the icon which will correspond to marker location
              "iconAnchor" => [20, 0]
            },
            "videoCount" => place.videos.count,
            "gameCount" => place.games.count,
            "imageCount" => place.photos.count,
            "heroImage" => !place.photos.blank? ? place.photos.first.path_url(:small) : "https://d1w99recw67lvf.cloudfront.net/category_icons/small_generic_" + place_type + ".jpg",
            "placeId" => place.slug,
            "area" => area_info
          }
        }
      end

      countries = Country.all
      countries.each do |country|
        geojson["countries"] << {
          properties: {
            "title" => country.display_name,
            "id" => country.id,
            "url" => '/countries/' + country.slug + '.html',
            "placeId" => country.slug
          }
        }
      end

      geojson
    end
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

  def check_valid_url
    if self.website
      unless website.match(/^(http:\/\/)/i) || website.match(/^(https:\/\/)/i)
        website.prepend("http://")
      end
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
    country = self.country
    g_parent = get_parents(self, parents = [])
    p_display_name = g_parent.collect{ |parent| parent.display_name }

    if p_display_name.blank?
      ["things to do with kids and families #{self.display_name}", :post_code]
    else
      primary_area_display_name = p_display_name.reverse.map {|str| str.downcase }.join(' ')
      ["things to do with kids and families #{primary_area_display_name} #{self.display_name}", :post_code]
    end
  end

  def get_parents(place, parents = [])
    unless !self.run_rake.blank?
      if place.parent.blank? || place.parent.parentable == self
        if !place.country.blank?
          parents << place.country
          return parents
        else
          return parents
        end
      else
        if place.parent.parentable.class.to_s.eql? "Region"
          parents << place.parent.parentable
          parents << place.country
          return parents
        else
          parents << place.parent.parentable

          if place.parent.parentable.class.to_s.eql? "Country"
            parents << place.country
            return parents
          else
            get_parents(place.parent.parentable, parents)
          end
        end
      end
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
    stories = stories.sort{|x, y| x.publish_date <=> y.publish_date}.reverse
  end

  def active_user_photos
    active_user_photos = self.user_photos.active
    photos = (self.photos.active + active_user_photos).sort {|x, y| x.created_at <=> y.created_at}

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

  def should_generate_new_friendly_id?
    unless !self.run_rake.blank?
      if self.parent.blank?
        slug.blank? || display_name_changed? || self.country_id_changed?
      else
        slug.blank? || display_name_changed? || self.country_id_changed? || self.parent.parentable_id_changed?#self.parent_id_changed?
      end
    end
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

  def autofill_short_description
    if self.description.present? && self.short_description.blank?
      self.short_description = self.description[0..254]
    end
  end

  def children
    list_of_children = []
    childrens.each do |child|
      unless child.itemable.blank?
        if child.itemable_type == "Attraction" && child.itemable.status == "live"
          list_of_children << child.itemable
        end
      end
    end
    list_of_children
  end

  def update_parentable_id
    self.parent.update(parentable_id: self.id)
  end

  private
    def algolia_id
      "place_#{id}" # ensure the place & country IDs are not conflicting
    end


  class << self
    def filter params= {}
      res= self.all#where(id: nil)
      if params.present?
        #res= res.joins(:primary_category)
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
