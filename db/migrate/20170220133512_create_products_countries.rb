class CreateProductsCountries < ActiveRecord::Migration
  def change
    create_table :spree_products_countries do |t|
      t.integer :product_id
      t.integer :country_id

      t.timestamps
    end
  end
end
