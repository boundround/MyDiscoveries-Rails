class PlacesWeatherCategory < ActiveRecord::Base
  belongs_to :weather_category
  belongs_to :place
end
