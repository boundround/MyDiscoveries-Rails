class RemoveSkuIndex < ActiveRecord::Migration
  def change
    remove_index :spree_variants, :sku
  end
end
