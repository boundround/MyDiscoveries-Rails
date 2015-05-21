class AddAddressColumnsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :street_number, :string
    add_column :places, :route, :string
    add_column :places, :sublocality, :string
    add_column :places, :locality, :string
    add_column :places, :country, :string
  end
end
