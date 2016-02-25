class DropWeatherCategories < ActiveRecord::Migration
  def change
    drop_table :weather_categories
  end
end
