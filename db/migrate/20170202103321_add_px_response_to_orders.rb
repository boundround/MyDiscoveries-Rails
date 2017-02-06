class AddPxResponseToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :px_response, :json, default: {}
  end
end
