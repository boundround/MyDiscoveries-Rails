class AddPrimaryKeyToUserPhotosUsers < ActiveRecord::Migration
  def change
    add_column :user_photos_users, :id, :primary_key
  end
end
