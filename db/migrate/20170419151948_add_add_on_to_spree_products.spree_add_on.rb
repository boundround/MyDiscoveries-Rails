# This migration comes from spree_add_on (originally 20131018180538)
class AddAddOnToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :add_on, :boolean, default: false
  end
end
