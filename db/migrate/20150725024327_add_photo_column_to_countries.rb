class AddPhotoColumnToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :hero_photo, :string
  end
end
