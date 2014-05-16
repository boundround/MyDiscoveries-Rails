class FixColumnName < ActiveRecord::Migration
  def self.up
    rename_column :areas, :icon_latitude, :latitude
    rename_column :areas, :icon_longitude, :longitude
  end
end
