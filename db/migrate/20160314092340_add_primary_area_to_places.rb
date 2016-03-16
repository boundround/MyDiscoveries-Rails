class AddPrimaryAreaToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :primary_area, :boolean
  end
end
