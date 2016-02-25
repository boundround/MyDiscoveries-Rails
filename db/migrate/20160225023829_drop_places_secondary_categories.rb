class DropPlacesSecondaryCategories < ActiveRecord::Migration
  def change
    drop_table :places_secondary_categories
  end
end
