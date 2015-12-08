class AddHeroImageToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :hero_image, :string
  end
end
