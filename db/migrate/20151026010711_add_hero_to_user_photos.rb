class AddHeroToUserPhotos < ActiveRecord::Migration
  def change
    add_column :user_photos, :hero, :boolean
  end
end
