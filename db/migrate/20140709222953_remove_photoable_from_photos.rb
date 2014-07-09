class RemovePhotoableFromPhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :photoable_id
    remove_column :photos, :photoable_type

    add_column :photos, :area_id, :integer
    add_column :photos, :place_id, :integer
  end
end
