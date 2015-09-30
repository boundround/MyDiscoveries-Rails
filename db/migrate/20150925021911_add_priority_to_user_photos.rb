class AddPriorityToUserPhotos < ActiveRecord::Migration
  def change
    add_column :user_photos, :priority, :integer
  end
end
