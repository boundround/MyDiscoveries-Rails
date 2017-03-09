class CreateProductsAttractions < ActiveRecord::Migration
  def change
    create_table :spree_products_attractions do |t|
      t.integer :product_id
      t.integer :attraction_id

      t.timestamps
    end
  end
end
