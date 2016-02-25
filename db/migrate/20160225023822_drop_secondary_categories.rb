class DropSecondaryCategories < ActiveRecord::Migration
  def change
    drop_table :secondary_categories
  end
end
