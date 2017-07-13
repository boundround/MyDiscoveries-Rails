class AddHubspotIdToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :hubspot_id, :string, default: ''
  end
end