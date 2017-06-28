class AddDisablePackageOptionToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_products, :disable_package_option, :boolean, default: false
  end
end
