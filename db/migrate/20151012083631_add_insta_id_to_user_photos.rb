class AddInstaIdToUserPhotos < ActiveRecord::Migration
  def change
    add_column :user_photos, :instagram_id, :string
    add_index :user_photos, :instagram_id, unique: true
  end
end
