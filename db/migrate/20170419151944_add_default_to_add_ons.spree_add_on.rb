# This migration comes from spree_add_on (originally 20130619202836)
class AddDefaultToAddOns < ActiveRecord::Migration
  def change
    add_column :spree_add_ons, :default, :boolean, default: false
  end
end
