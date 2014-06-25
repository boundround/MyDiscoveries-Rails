class Place < ActiveRecord::Base
  include FriendlyId
  friendly_id :display_name, :use => :slugged
  validates_presence_of :display_name, :slug

  has_many :photos, as: :photoable
  accepts_nested_attributes_for :photos

  belongs_to :area

  def Place.all_geojson
    geojson = Array.new

    places = Place.all

    places.each do |place|
      geojson << {
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
end
