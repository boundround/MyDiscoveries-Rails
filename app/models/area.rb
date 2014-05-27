class Area < ActiveRecord::Base
  has_many :photos
  accepts_nested_attributes_for :photos

  validates :display_name, uniqueness: { case_sensitive: false }, presence: true
  validates :code, uniqueness: { case_sensitive: false }, presence: true, length: {is: 3}
  validates :short_intro, length: {maximum: 90}, presence: true
  validates :description, length: {maximum: 500}, presence: true

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
          "icon" => {
            "iconUrl" => ActionController::Base.helpers.asset_path("marmite.jpg", type: :image),
            # size of the icon
            "iconSize" => [50, 50],
            # point of the icon which will correspond to marker location
            "iconAnchor" => [25, 25],
            # point from which the popup should open relative to the iconAnchor
            "popupAnchor" => [0, -25]
          }
        }
        # address: area.address,
        # :'marker-color' => '#00607d',
        # :'marker-symbol' => 'airplane',
        # :'marker-size' => 'medium'
        # }
      }
    end

    return geojson
  end
end
