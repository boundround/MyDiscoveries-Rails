class AddAdminOnlyActiveFlagToSpreeAddOns < ActiveRecord::Migration
  def change
    add_column :spree_add_ons, :admin_only_active, :boolean, default: false 
  end
end
