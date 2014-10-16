class Area < ActiveRecord::Base
  include FriendlyId
  friendly_id :display_name, :use => :slugged

  scope :active, -> { where.not(published_status: ['out', 'draft']) }

  validates_presence_of :display_name, :slug
  has_many :videos
<<<<<<< HEAD
  has_many :places, -> { order(:display_name) }

=======
  has_many :places
>>>>>>> clean-up
  has_many :photos
  accepts_nested_attributes_for :photos

  validates :display_name, uniqueness: { case_sensitive: false }, presence: true


  after_update :flush_area_cache # May be able to be removed
  after_update :flush_areas_geojson


  def flush_area_cache # May be able to be removed
    Rails.cache.delete('all_areas')
  end

  def Area.all_areas # May be able to be removed
    Rails.cache.fetch("all_areas") { Area.includes(:places) }
  end

  def flush_places_geojson
    Rails.cache.delete('areas_geojson')
  end

<<<<<<< HEAD
    areas = self.all_areas
    areas.each do |area|
      next if area.published_status == 'draft' || area.published_status == 'out'
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
          "places" => !area.places.all? { |place| place.subscription_level == "draft" || place.subscription_level == "out" },
          "icon" => {
            "iconUrl" => 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png',
            # size of the icon
            "iconSize" => [43, 26],
            # point of the icon which will correspond to marker location
            "iconAnchor" => [20, 0]
=======
  def Area.all_geojson
    # Fetch place GeoJSON from cache or store it in the cache.
    Rails.cache.fetch('areas_geojson') do
      geojson = {"type" => "FeatureCollection","features" => []}
      areas = self.active.includes(:places)
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
            "places" => !area.places.all? { |place| place.subscription_level == "draft" },
            "icon" => {
              "iconUrl" => 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png',
              # size of the icon
              "iconSize" => [43, 26],
              # point of the icon which will correspond to marker location
              "iconAnchor" => [20, 0]
            }
>>>>>>> clean-up
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

end
