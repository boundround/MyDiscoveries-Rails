class AddAxSalesIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :ax_sales_id, :string
  end
end
