class AddRelatedToToSubcategory < ActiveRecord::Migration
  def change
  	add_column :subcategories, :related_to, :string
  end
end
