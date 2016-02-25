class DropAccessibilityCategories < ActiveRecord::Migration
  def change
    drop_table :accessibility_categories
  end
end
