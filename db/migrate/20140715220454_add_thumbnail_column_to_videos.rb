class AddThumbnailColumnToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :vimeo_thumbnail, :string
  end
end
