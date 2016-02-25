class DropAccessibilityCategoryPlaces < ActiveRecord::Migration
  def change
    drop_table :accessibility_categories_places
  end
end
