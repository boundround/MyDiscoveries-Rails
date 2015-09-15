class Area < ActiveRecord::Base
  extend FriendlyId

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

  friendly_id :display_name, :use => :slugged

  has_paper_trail

  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

  scope :active, -> { where(published_status: "live") }
  scope :preview, -> { where('published_status=? OR published_status=?', 'live', 'edited') }

  validates_presence_of :display_name, :slug

  belongs_to :country

  has_many :videos, -> { order "created_at ASC"}
  has_many :places, -> { order(:display_name) }
  has_many :games, -> { order "created_at ASC"}
  has_many :fun_facts, -> { order "created_at ASC"}
  has_many :discounts, -> { order "created_at ASC"}
  has_many :user_photos

  has_many :photos
  has_many :user_photos

  has_many :areas_users
  has_many :users, through: :areas_users

  has_many :reviews, as: :reviewable
  has_many :stories, as: :storiable

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :fun_facts, allow_destroy: true
  accepts_nested_attributes_for :discounts, allow_destroy: true
  accepts_nested_attributes_for :games, allow_destroy: true
  accepts_nested_attributes_for :user_photos
  accepts_nested_attributes_for :reviews
  accepts_nested_attributes_for :stories

  validates :display_name, uniqueness: { case_sensitive: false }, presence: true


  after_update :flush_area_cache # May be able to be removed
  after_update :flush_areas_geojson


  def flush_area_cache # May be able to be removed
    Rails.cache.delete('all_areas')
  end

  def Area.all_areas # May be able to be removed
    Rails.cache.fetch("all_areas") { Area.includes(:places) }
  end

  def flush_areas_geojson
    Rails.cache.delete('areas_geojson')
  end

  def Area.all_geojson
    # Fetch place GeoJSON from cache or store it in the cache.
    Rails.cache.fetch('areas_geojson') do
      geojson = {"type" => "FeatureCollection","features" => []}
      areas = self.active.includes(:country, places: [:photos, :country])
      areas.each do |area|
        geojson['features'] << {
          type: 'Feature',
          geometry: {
            type: 'Point',
            coordinates: [area.longitude, area.latitude]
          },
          properties: {
            "title"=> area.display_name,
            "url" => '/areas/' + area.slug + '.html',
            "id" => area.id,
            "places" => area.places.all? { |place| place.status = "live" },
            "icon" => {
              "iconUrl" => 'https://s3-ap-southeast-2.amazonaws.com/brwebproduction/vector_icons/orange_plane.png',
              # size of the icon
              "iconSize" => [43, 26],
              # point of the icon which will correspond to marker location
              "iconAnchor" => [20, 0]
            },
            "placeCount" => area.places.length,
            "country" => (area.country ? area.country.display_name : "")
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
    Area.create!(row.to_h)
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
    display_name_changed?
  end

  def load_into_soulmate
    if self.published_status == "live"
      loader = Soulmate::Loader.new("area")
      loader.add("term" => display_name.downcase, "display_name" => display_name, "id" => id, "description" => description,
                  "latitude" => latitude, "longitude" => longitude, "url" => '/areas/' + slug + '.html', "slug" => slug, "country" => (self.country ? self.country.display_name : ""), "placeType" => "area")
    else
      self.remove_from_soulmate
    end
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("area")
    loader.remove("id" => self.id)
  end

end
