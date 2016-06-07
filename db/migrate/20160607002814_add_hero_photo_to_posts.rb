class AddHeroPhotoToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :hero_photo, :string
  end
end
