class AddPriceToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :full_price, :decimal, default: 0.0, precision: 8, scale: 2
  end
end
