class CreateProductsPhotos < ActiveRecord::Migration
  def change
    create_table :spree_products_photos do |t|
      t.integer :photo_id
      t.integer :product_id

      t.timestamps
    end
  end
end
