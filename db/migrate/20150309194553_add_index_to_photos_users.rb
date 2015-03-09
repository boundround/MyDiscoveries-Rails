class AddIndexToPhotosUsers < ActiveRecord::Migration
  def change
    add_index :photos_users, [:photo_id, :user_id], :unique => true
  end
end
