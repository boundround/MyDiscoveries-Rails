class RenameProductType < ActiveRecord::Migration
  def change
    remove_column :spree_products, :product_type
    add_column :spree_products, :product_type_id, :integer
  end
end
