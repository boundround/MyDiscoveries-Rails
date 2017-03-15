class AddAxDataToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :ax_data, :json, default: {}
  end
end
