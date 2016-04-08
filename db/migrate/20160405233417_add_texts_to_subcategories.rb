class AddTextsToSubcategories < ActiveRecord::Migration
  def change
    add_column :subcategories, :primary_description, :text
    add_column :subcategories, :secondary_description, :text
  end
end
