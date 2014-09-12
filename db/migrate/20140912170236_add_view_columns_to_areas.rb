class AddViewColumnsToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :view_latitude, :float
    add_column :areas, :view_longitude, :float
    add_column :areas, :view_height, :float
    add_column :areas, :view_heading, :float
  end
end
