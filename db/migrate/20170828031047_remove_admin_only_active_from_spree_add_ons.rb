class RemoveAdminOnlyActiveFromSpreeAddOns < ActiveRecord::Migration
  def change
    remove_column :spree_add_ons, :admin_only_active, :boolean, default: false 
    add_column :spree_add_ons, :active_for_admin, :boolean, default: false 
  end
end
