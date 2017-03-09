class AddPurchaseDateToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :purchase_date, :datetime    
  end
end
