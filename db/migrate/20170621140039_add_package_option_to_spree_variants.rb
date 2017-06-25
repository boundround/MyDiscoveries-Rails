class AddPackageOptionToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :package_option, :string
  end
end
