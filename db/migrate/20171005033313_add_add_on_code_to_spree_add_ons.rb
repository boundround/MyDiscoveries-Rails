class AddAddOnCodeToSpreeAddOns < ActiveRecord::Migration
  def change
    add_column :spree_add_ons, :add_on_code, :string, default: ''
  end
end
