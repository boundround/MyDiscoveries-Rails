class AddSnaResponseToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :sna_response, :text, default: ''
  end
end
