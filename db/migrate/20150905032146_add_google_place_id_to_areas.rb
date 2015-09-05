class AddGooglePlaceIdToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :google_place_id, :string
  end
end
