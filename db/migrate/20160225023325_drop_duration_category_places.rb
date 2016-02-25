class DropDurationCategoryPlaces < ActiveRecord::Migration
  def change
    drop_table :duration_categories_places
  end
end
