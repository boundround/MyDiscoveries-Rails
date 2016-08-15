class AddAltTagToUserPhotos < ActiveRecord::Migration
  def change
    add_column :user_photos, :alt_tag, :text
  end
end
