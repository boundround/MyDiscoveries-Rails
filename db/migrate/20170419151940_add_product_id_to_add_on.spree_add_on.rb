# This migration comes from spree_add_on (originally 20130613231625)
class AddProductIdToAddOn < ActiveRecord::Migration
  def change
    add_column :spree_add_ons, :product_id, :integer
    add_index :spree_add_ons, :product_id
  end
end
