class AddTestProductToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :test_product, :boolean, default: false
  end
end
