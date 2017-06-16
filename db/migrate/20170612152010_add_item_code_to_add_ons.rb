class AddItemCodeToAddOns < ActiveRecord::Migration
  def change
    add_column :spree_add_ons, :item_code, :string, default: ''
  end
end
