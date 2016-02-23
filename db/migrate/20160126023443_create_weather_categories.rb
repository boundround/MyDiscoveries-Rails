class CreateWeatherCategories < ActiveRecord::Migration
  def change
    create_table :weather_categories do |t|
      t.string :name
      t.string :identifier

      t.timestamps
    end
  end
end