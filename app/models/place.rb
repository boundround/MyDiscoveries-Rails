class Place < ActiveRecord::Base
  include CustomerApprovable
  include AlgoliaSearch

  algoliasearch index_name: 'place', id: :algolia_id, if: :published? do
    # list of attribute used to build an Algolia record
    attributes :display_name, :latitude, :longitude, :locality, :post_code, :display_address
    attribute :country do
      if self.country
        "#{country.display_name}"
      else
        ""
      end
    end
    attribute :url do
      "/places/#{slug}"
    end

    attribute :description do
      if description
        if description.length < 50
          "#{description}"
        else
          "#{description[0..50]}..."
        end
      else
        ""
      end
    end

    attribute :category do
      if categories.blank?
        "sights"
      elsif categories.any? {|category| category.identifier == "area"}
        "area"
      else
        categories[0].identifier
      end
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
     #country and url

    # the attributesToIndex` setting defines the attributes
    # you want to search in: here `title`, `subtitle` & `description`.
    # You need to list them by order of importance. `description` is tagged as
    # `unordered` to avoid taking the position of a match into account in that attribute.
    attributesToIndex ['display_name', 'unordered(description)', 'unordered(display_address)']

    # the `customRanking` setting defines the ranking criteria use to compare two matching
    # records in case their text-relevance is equal. It should reflect your record popularity.
    # customRanking ['desc(likes_count)']
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

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate
  before_save :check_valid_url, :set_approval_time

  has_paper_trail

  resourcify

  acts_as_taggable
  acts_as_taggable_on :locations, :activities

  extend FriendlyId
  friendly_id :slug_candidates, :use => :slugged #show display_names in place routes

  # default_scope { order('display_name ASC') } ## This screwed up programs query by calling it implicitly on a join query

  scope :active, -> { where(status: "live") }
  scope :not_removed, -> { where('status != ?', 'removed') }
  scope :preview, -> { where('status=? OR status=?', 'live', 'edited') }

  scope :publishing_queue, -> { where('published_at <= ?', Time.now) }
  scope :removal_queue, -> { where('unpublished_at <= ?', Time.now) }

  scope :to_be_published, -> { where('published_at >= ?', Time.now) }
  scope :to_be_removed, -> { where('unpublished_at >= ?', Time.now) }

  # include PgSearch
  # pg_search_scope :search, against: [:display_name, :description],
  #   using: {tsearch: {dictionary: "english"}},
  #   associated_against: {photos: :caption, area: [:display_name, :description]}

  validates_presence_of :display_name, :slug

  belongs_to :area
  belongs_to :country
  belongs_to :user
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :photos, -> { order "created_at ASC"}
  has_many :discounts, -> { order "created_at ASC"}
  has_many :games, -> { order "created_at ASC"}
  has_many :videos, -> { order "created_at ASC"}
  has_many :fun_facts, -> { order "created_at ASC"}
  has_many :programs, -> { order "created_at ASC"}
  has_many :user_photos
  has_one :journal_info

  has_many :places_users
  has_many :users, through: :places_users

  has_many :customers_places
  has_many :owners, through: :customers_places, :source => :user

  has_many :reviews, as: :reviewable
  has_many :stories, as: :storiable

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :fun_facts, allow_destroy: true
  accepts_nested_attributes_for :discounts, allow_destroy: true
  accepts_nested_attributes_for :games, allow_destroy: true
  accepts_nested_attributes_for :programs, allow_destroy: true
  accepts_nested_attributes_for :reviews, allow_destroy: true
  accepts_nested_attributes_for :stories, allow_destroy: true
  accepts_nested_attributes_for :user_photos, allow_destroy: true

  mount_uploader :map_icon, IconUploader

  after_update :flush_place_cache # May be able to be removed
  after_update :flush_places_geojson

  def published?
    if self.status == "live"
      true
    else
      false
    end
  end

  # def self.text_search(query)
  #   if query.present?
  #     search(query)
  #   else
  #     scoped
  #   end
  # end

  def flush_place_cache #May be able to be removed
    Rails.cache.delete('all_places')
  end

  def Place.all_places #May be able to be removed
    Rails.cache.fetch("all_places") { Place.includes(:categories) }
  end

  def flush_places_geojson
    Rails.cache.delete('places_geojson')
  end

  def Place.all_placeareas_geojson
    # Fetch place GeoJSON from cache or store it in the cache.
#    Rails.cache.fetch('placeareas_geojson') do
      geojson = {"type" => "FeatureCollection","features" => []}
      places = self.active.includes(:categories, :country).where(:categories => {:name => 'Area'})
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
      places = self.active.includes(:categories, :games, :videos, :photos, :country, :area => [:country, :places])
      places.each do |place|
        if place.area != nil
          area_info = {"title" => place.area.display_name, "url" => '/areas/' + place.area.slug + '.html', 'placeCount' => place.area.places.length, "country" => (place.country ? place.country.display_name : "") }
        end
        # Assign icon based on 'premium' level and category
        if place.categories[0].nil?
          place_type = 'sights'
        else
          place_type = place.categories[0].identifier
        end

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
            "videoCount" => place.videos.length,
            "gameCount" => place.games.length,
            "imageCount" => place.photos.length,
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

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when '.csv' then Csv.new(file.path, nil, :ignore)
      when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
      when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def should_generate_new_friendly_id?
    display_name_changed? || super
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
      loader.add("term" => display_name.downcase + ' ' + (description ? description.downcase : "") + ' ' + (self.area_id ? self.area.display_name.downcase : ""),
                "display_name" => display_name, "id" => id, "latitude" => latitude, "longitude" => longitude,
                "url" => '/places/' + slug + '.html', "slug" => slug, "placeType" => "place",
                "area" => {"display_name" => (self.area_id ? self.area.display_name : (self.locality ? self.locality : "")), "country" => (self.country ? self.country.display_name : "") })
    else
      self.remove_from_soulmate
    end
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("place")
    loader.remove("id" => self.id)
  end

  def slug_candidates
    [
      :display_name,
      [:display_name, :post_code]
    ]
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

  private
    def algolia_id
      "place_#{id}" # ensure the place & country IDs are not conflicting
    end

end
