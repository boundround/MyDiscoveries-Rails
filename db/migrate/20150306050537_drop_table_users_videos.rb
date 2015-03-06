class DropTableUsersVideos < ActiveRecord::Migration
  def change
    drop_table :users_videos
  end
end
