class Place < ActiveRecord::Base
  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate
  before_save :check_valid_url

  include FriendlyId
  friendly_id :display_name, :use => :slugged #show display_names in place routes

  scope :active, -> { where.not(subscription_level: ['out', 'draft']) }

  include PgSearch
  pg_search_scope :search, against: [:display_name, :description],
    using: {tsearch: {dictionary: "english"}},
    associated_against: {photos: :caption, area: [:display_name, :description]}

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
          area_info = {"title" => place.area.display_name, "url" => '/areas/' + place.area.slug + '.html', 'placeCount' => place.area.places.length, "country" => place.area.country}
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

              "iconUrl" => "http://d1w99recw67lvf.cloudfront.net/category_icons/" + icon_file_name,

              # size of the icon
              "iconSize" => [20, 45],
              # point of the icon which will correspond to marker location
              "iconAnchor" => [20, 0]
            },
            "videoCount" => place.videos.length,
            "gameCount" => place.games.length,
            "imageCount" => place.photos.length,
            "heroImage" => place.get_card_image,
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

  def load_into_soulmate
    puts id
    if self.subscription_level.downcase == 'premium' || self.subscription_level.downcase == 'standard' || self.subscription_level == 'basic'
      loader = Soulmate::Loader.new("place")
      loader.add("term" => display_name.downcase + ' ' + description.downcase + ' ' + self.area.display_name.downcase,
                "display_name" => display_name, "id" => id, "latitude" => latitude, "longitude" => longitude,
                "url" => '/places/' + slug + '.html', "slug" => slug,
                "area" => {"display_name" => self.area.display_name, "country" => self.area.country})
    end
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("place")
    loader.remove("id" => self.id)
  end

end
