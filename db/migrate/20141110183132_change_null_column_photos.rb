class ChangeNullColumnPhotos < ActiveRecord::Migration
  def change
    change_column :photos, :path, :string, :null => true
  end
end
