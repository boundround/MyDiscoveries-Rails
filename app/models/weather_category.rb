class WeatherCategory < ActiveRecord::Base
  include Parameterizable
  before_save :parameterize_identifier
  has_many :places_weather_categories
  has_many :places, through: :places_weather_categories
end
