class ChangeAddIdentifierToSubcategories < ActiveRecord::Migration
  def change
  	add_column :subcategories, :identifier, :text
  end
end