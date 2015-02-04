class AddAltTagToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :alt_tag, :string
  end
end
