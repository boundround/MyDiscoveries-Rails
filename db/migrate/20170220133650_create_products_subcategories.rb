class CreateProductsSubcategories < ActiveRecord::Migration
  def change
    create_table :spree_products_subcategories do |t|
      t.integer :product_id
      t.integer :subcategory_id

      t.timestamps
    end
  end
end
