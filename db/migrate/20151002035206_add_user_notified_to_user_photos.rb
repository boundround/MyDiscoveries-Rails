class AddUserNotifiedToUserPhotos < ActiveRecord::Migration
  def change
    add_column :user_photos, :user_notified, :boolean
    add_column :user_photos, :user_notified_at, :datetime
  end
end
