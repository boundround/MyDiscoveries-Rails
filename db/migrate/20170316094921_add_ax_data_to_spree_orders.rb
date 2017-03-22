class AddAxDataToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :ax_data, :json, default: {}
  end
end
