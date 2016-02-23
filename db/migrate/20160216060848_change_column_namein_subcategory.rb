class ChangeColumnNameinSubcategory < ActiveRecord::Migration
  def change
  	rename_column :subcategories, :type, :category_type
  end
end
