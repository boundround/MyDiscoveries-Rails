class AddPurchaseDateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :purchase_date, :datetime
  end
end
