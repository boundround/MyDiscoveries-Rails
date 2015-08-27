class Place < ActiveRecord::Base
  include CustomerApprovable

  ratyrate_rateable "quality"

  geocoded_by :display_address   # can also be an IP address
  after_validation :geocode

  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate
  before_save :check_valid_url, :set_approval_time

  has_paper_trail

  resourcify

  acts_as_taggable
  acts_as_taggable_on :locations, :activities

  extend FriendlyId
  friendly_id :slug_candidates, :use => :slugged #show display_names in place routes

  scope :active, -> { where(status: "live") }
  scope :preview, -> { where('status=? OR status=?', 'live', 'edited') }

  scope :publishing_queue, -> { where('published_at <= ?', Time.now) }
  scope :removal_queue, -> { where('unpublished_at <= ?', Time.now) }

  scope :to_be_published, -> { where('published_at >= ?', Time.now) }
  scope :to_be_removed, -> { where('unpublished_at >= ?', Time.now) }

  include PgSearch
  pg_search_scope :search, against: [:display_name, :description],
    using: {tsearch: {dictionary: "english"}},
    associated_against: {photos: :caption, area: [:display_name, :description]}

  validates_presence_of :display_name, :slug

  belongs_to :area
  belongs_to :country
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :photos, -> { order "created_at ASC"}
  has_many :discounts, -> { order "created_at ASC"}
  has_many :games, -> { order "created_at ASC"}
  has_many :videos, -> { order "created_at ASC"}
  has_many :fun_facts, -> { order "created_at ASC"}
  has_many :programs, -> { order "created_at ASC"}
  has_one :journal_info

  has_many :places_users
  has_many :users, through: :places_users

  has_many :customers_places
  has_many :owners, through: :customers_places, :source => :user

  has_many :reviews, as: :reviewable

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :fun_facts, allow_destroy: true
  accepts_nested_attributes_for :discounts, allow_destroy: true
  accepts_nested_attributes_for :games, allow_destroy: true
  accepts_nested_attributes_for :programs, allow_destroy: true
  accepts_nested_attributes_for :reviews

  mount_uploader :map_icon, IconUploader

  after_update :flush_place_cache # May be able to be removed
  after_update :flush_places_geojson


  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end

  def flush_place_cache #May be able to be removed
    Rails.cache.delete('all_places')
  end

  def Place.all_places #May be able to be removed
    Rails.cache.fetch("all_places") { Place.includes(:categories) }
  end

  def flush_places_geojson
    Rails.cache.delete('places_geojson')
  end

  def Place.all_geojson
    # Fetch place GeoJSON from cache or store it in the cache.
    Rails.cache.fetch('places_geojson') do
      geojson = {"type" => "FeatureCollection","features" => []}
      places = self.active.includes(:categories, :games, :videos, :photos)
      places.each do |place|
        if place.area != nil
          area_info = {"title" => place.area.display_name, "url" => '/areas/' + place.area.slug + '.html', 'placeCount' => place.area.places.active ? place.area.places.active.length : 0, "country" => (place.country ? place.country.display_name : "") }
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
            "heroImage" => !place.photos.blank? ? place.photos.first.path_url(:small) : "http://placehold.it/350x150",
            "placeId" => place.slug,
            "area" => area_info
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

end
