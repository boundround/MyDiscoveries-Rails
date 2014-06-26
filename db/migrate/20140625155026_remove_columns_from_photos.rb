class RemoveColumnsFromPhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :area_id, :integer
    remove_column :photos, :place_id, :integer
  end
end
