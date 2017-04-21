class AddSupplierProductCodeToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :supplier_product_code, :string
  end
end
