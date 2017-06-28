class AddMiscellaneousChargesToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :miscellaneous_charges, :boolean, default: false    
  end
end
