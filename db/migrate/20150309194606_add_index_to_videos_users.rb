class AddIndexToVideosUsers < ActiveRecord::Migration
  def change
    add_index :videos_users, [:video_id, :user_id], :unique => true
  end
end
