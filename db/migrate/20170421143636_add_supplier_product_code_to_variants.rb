class AddSupplierProductCodeToVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :supplier_product_code, :string, default: ""
  end
end
