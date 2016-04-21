class AddCountryHeroToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :country_hero, :boolean
  end
end
