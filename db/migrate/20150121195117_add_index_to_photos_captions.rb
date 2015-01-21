class AddIndexToPhotosCaptions < ActiveRecord::Migration
  def change
    add_index :photos, :caption
  end
end
