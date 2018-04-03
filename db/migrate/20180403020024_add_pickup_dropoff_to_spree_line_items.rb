class AddPickupDropoffToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :pickup_address, :text, default: ''
    add_column :spree_line_items, :dropoff_airport, :text, default: ''
  end
end
