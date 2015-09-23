class AddGooglePlaceIdToUserPhotos < ActiveRecord::Migration
  def change
    add_column :user_photos, :google_place_id, :string
  end
end
