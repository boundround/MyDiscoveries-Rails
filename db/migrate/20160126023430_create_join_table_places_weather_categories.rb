class CreateJoinTablePlacesWeatherCategories < ActiveRecord::Migration
  def change
    create_join_table :places, :weather_categories do |t|
      # t.index [:place_id, :weather_category_id]
      # t.index [:weather_category_id, :place_id]
    end
  end
end
