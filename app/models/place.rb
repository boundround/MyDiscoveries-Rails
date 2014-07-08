class Place < ActiveRecord::Base
  include FriendlyId
  friendly_id :display_name, :use => :slugged
  validates_presence_of :display_name, :slug

  belongs_to :area
  has_many :photos, as: :photoable
  has_many :discounts
  has_many :games
  has_many :videos
  accepts_nested_attributes_for :photos



  def Place.all_geojson
    geojson = {"type" => "FeatureCollection","features" => []}

    places = Place.all
    places.each do |place|
      geojson['features'] << {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [place.longitude, place.latitude]
        },
        properties: {
          "title"=> place.display_name,
          "id" => place.id,
          "icon" => {
            "iconUrl" => 'https://ae0fbee68772d543f2c5-e02ea5f9f7cbf68a786b2624900f7447.ssl.cf4.rackcdn.com/icons20140522/Do_generic_yellow_m.png',
            # size of the icon
            "iconSize" => [43, 26],
            # point of the icon which will correspond to marker location
            "iconAnchor" => [20, 0]
          }
        }
      }
    end

    return geojson
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

end
