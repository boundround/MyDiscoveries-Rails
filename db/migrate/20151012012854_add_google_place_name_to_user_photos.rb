class AddGooglePlaceNameToUserPhotos < ActiveRecord::Migration
  def change
    add_column :user_photos, :google_place_name, :string
  end
end
