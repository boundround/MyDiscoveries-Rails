class AddSentSnaToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :sent_to_sna, :boolean, default: false
  end
end
