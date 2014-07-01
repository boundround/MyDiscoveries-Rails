class RemoveHeroColumnFromPhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :hero, :boolean
  end
end
