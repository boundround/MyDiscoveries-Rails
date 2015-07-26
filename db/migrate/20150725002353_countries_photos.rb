class CountriesPhotos < ActiveRecord::Migration
  def change
    create_table :countries_photos do |t|
      t.integer :country_id
      t.integer :photo_id
    end
  end
end
