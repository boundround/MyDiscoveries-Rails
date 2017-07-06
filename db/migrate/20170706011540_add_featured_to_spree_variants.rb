class AddFeaturedToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :featured, :boolean, default: false
  end
end
