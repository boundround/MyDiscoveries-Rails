class AddPickupDropoffToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :pickup_dropoff, :boolean, default: false
  end
end
