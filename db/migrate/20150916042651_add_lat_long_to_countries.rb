class AddLatLongToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :latitude, :float
    add_column :countries, :longitude, :float
    add_column :countries, :address, :string
  end
end
