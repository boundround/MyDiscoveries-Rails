class CreateProductsPlaces < ActiveRecord::Migration
  def change
    create_table :spree_products_places do |t|
      t.integer :product_id
      t.integer :place_id

      t.timestamps
    end
  end
end
