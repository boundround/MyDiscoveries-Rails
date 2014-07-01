class AddHeroColumnToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :hero, :boolean
  end
end
