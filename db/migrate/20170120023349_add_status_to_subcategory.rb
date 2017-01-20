class AddStatusToSubcategory < ActiveRecord::Migration
  def change
  	add_column :subcategories, :status, :string
  end
end
