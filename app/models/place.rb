class Place < ActiveRecord::Base
  before_save :check_valid_url

  include FriendlyId
  friendly_id :display_name, :use => :slugged #show display_names in place routes

  scope :active, -> { where.not(subscription_level: ['out', 'draft']) }

  validates_presence_of :display_name, :slug

  belongs_to :area
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :photos
  has_many :discounts
  has_many :games
  has_many :videos
  has_one :journal_info
  accepts_nested_attributes_for :photos

  mount_uploader :map_icon, IconUploader

  after_update :flush_place_cache # May be able to be removed
  after_update :flush_places_geojson

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
      places = self.active.includes(:categories, :games, :videos)
      places.each do |place|

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

              "iconUrl" => "http://d1w99recw67lvf.cloudfront.net/category_icons/" + icon_file_name,

              # size of the icon
              "iconSize" => [20, 45],
              # point of the icon which will correspond to marker location
              "iconAnchor" => [20, 0]
            },
            "videoCount" => place.videos.length,
            "gameCount" => place.games.length,
            "imageCount" => place.photos.length,
            "heroImage" => place.get_card_image
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
    display_name_changed?
  end

  def get_card_image
    if photos.empty?
      "http://placehold.it/350x150"
    else
      photos.order(:priority).first.path_url(:small)
    end
  end

  def check_valid_url
    if !website.match(/^(http:\/\/)/i) || !website.match(/^(http:\/\/)/i)
      website.prepend("http://")
    end
  end

end
