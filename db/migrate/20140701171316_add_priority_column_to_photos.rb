class AddPriorityColumnToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :priority, :integer
  end
end
