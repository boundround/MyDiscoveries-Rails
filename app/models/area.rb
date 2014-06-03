class Area < ActiveRecord::Base
  include FriendlyId
  friendly_id :display_name, :use => :slugged
  validates_presence_of :display_name, :slug

  has_many :photos
  accepts_nested_attributes_for :photos

  validates :display_name, uniqueness: { case_sensitive: false }, presence: true
  validates :code, uniqueness: { case_sensitive: false }, presence: true, length: {is: 3}
  validates :short_intro, length: {maximum: 90}
  validates :description, length: {maximum: 500}

  def Area.all_geojson
    geojson = Array.new

    areas = Area.all

    areas.each do |area|
      geojson << {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [area.longitude, area.latitude]
        },
        properties: {
          "title" => area.display_name,
          "id" => area.id,
          "icon" => {
            "iconUrl" => 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png',
            # size of the icon
            "iconSize" => [43, 26],
            # point of the icon which will correspond to marker location
            "iconAnchor" => [0, 0],
            # point from which the popup should open relative to the iconAnchor
            "popupAnchor" => [0, -25]
          }
        }
      }
    end

    return geojson
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
    Area.create!(row.to_h)
    end
  end

end


