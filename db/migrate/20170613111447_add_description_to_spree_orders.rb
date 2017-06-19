class AddDescriptionToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :description, :text
  end
end
