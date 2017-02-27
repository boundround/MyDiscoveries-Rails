class AddVoucherSentToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :voucher_sent, :boolean, default: false    
  end
end
