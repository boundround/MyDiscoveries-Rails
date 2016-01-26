class RenameIsAreaOnPlaces < ActiveRecord::Migration
  def change
    rename_column :places, :is_area?, :is_area
  end
end
