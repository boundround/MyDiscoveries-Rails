class AddShopifyProductIdToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :shopify_product_id, :string

    add_index :offers, :shopify_product_id
  end
end
