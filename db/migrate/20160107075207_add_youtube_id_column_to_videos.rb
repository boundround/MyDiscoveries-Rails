class AddYoutubeIdColumnToVideos < ActiveRecord::Migration
  def change
     add_column :videos, :youtube_id, :string, :default => ""
  end
end
