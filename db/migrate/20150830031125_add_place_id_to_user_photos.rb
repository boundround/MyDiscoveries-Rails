class AddPlaceIdToUserPhotos < ActiveRecord::Migration
  def change
    add_reference :user_photos, :place, index: true
  end
end
