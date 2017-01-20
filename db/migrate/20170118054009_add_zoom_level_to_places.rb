class AddZoomLevelToPlaces < ActiveRecord::Migration
  def change
  	add_column :places, :zoom_level, :integer
  end
end
