class DropCountriesFromPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :country
  end
end
