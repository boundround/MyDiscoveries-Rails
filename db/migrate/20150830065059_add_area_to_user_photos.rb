class AddAreaToUserPhotos < ActiveRecord::Migration
  def change
    add_reference :user_photos, :area, index: true
  end
end
