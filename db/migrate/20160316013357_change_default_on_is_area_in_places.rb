class ChangeDefaultOnIsAreaInPlaces < ActiveRecord::Migration
  def change
    change_column :places, :is_area, :boolean, default: false
  end
end
