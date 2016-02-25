class DropPlaceWeatherCategories < ActiveRecord::Migration
  def change
    drop_table :places_weather_categories
  end
end
