class AddNoNullToPhotos < ActiveRecord::Migration
  def change
    change_column_null(:photos, :path, false)
  end
end
