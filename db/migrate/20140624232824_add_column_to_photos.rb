class AddColumnToPhotos < ActiveRecord::Migration
  def change
    add_reference :photos, :place, index: true
  end
end
