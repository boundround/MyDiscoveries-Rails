class AddCountryIncludeToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :country_include, :boolean
  end
end
