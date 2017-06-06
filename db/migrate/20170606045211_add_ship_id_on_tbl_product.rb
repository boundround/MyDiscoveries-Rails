class AddShipIdOnTblProduct < ActiveRecord::Migration
  def change
  	add_column :spree_products, :ship_id, :integer
  end
end