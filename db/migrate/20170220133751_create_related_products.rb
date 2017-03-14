class CreateRelatedProducts < ActiveRecord::Migration
  def change
    create_table :spree_related_products do |t|
      t.integer :product_id
      t.integer :spree_related_product_id

      t.timestamps
    end
  end
end
