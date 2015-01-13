class RenameThumbnailUrl < ActiveRecord::Migration
  def change
    rename_column :games, :thumbnail_url, :thumbnail
  end
end
