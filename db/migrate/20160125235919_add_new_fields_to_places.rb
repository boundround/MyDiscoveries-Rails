class AddNewFieldsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :minimum_age, :integer
    add_column :places, :maximum_age, :integer
    add_column :places, :price_category, :integer
    add_column :places, :weather_conditions, :string
  end
end
