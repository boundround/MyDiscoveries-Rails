class WeatherCategory < ActiveRecord::Base
  has_many :places_weather_categories
  has_many :places, through: :places_weather_categories
end
