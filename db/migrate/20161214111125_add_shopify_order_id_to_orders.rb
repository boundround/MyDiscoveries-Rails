class AddShopifyOrderIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shopify_order_id, :string
  end
end
