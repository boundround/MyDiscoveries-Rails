class AddGooglePlaceIdToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :google_place_id, :string
  end
end
