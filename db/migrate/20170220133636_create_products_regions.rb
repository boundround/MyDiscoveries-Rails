class CreateProductsRegions < ActiveRecord::Migration
  def change
    create_table :spree_products_regions do |t|
      t.integer :product_id
      t.integer :region_id

      t.timestamps
    end
  end
end
