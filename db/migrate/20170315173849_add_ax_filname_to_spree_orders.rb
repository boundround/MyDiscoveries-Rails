class AddAxFilnameToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :ax_filename, :string
  end
end
