class AddPrimaryKeyToPhotosUsers < ActiveRecord::Migration
  def change
    add_column :photos_users, :id, :primary_key
  end
end
