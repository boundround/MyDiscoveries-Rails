class AddDisableMaturityToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :disable_maturity, :boolean, default: false
  end
end
