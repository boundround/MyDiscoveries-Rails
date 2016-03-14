class AddIconToSubCategories < ActiveRecord::Migration
  def change
  	add_column :subcategories, :icon, :string
  	add_column :places_subcategories, :desc, :text
  	add_column :places_subcategories, :id, :primary_key
  end
end
