class RemoveUserPhotoFromStories < ActiveRecord::Migration
  def change
    remove_column :stories, :user_photo_id, :integer
  end
end
