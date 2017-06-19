# This migration comes from spree_add_on (originally 20130618171339)
class AddTypeToAddOn < ActiveRecord::Migration
  def change
    add_column :spree_add_ons, :type, :string
  end
end
