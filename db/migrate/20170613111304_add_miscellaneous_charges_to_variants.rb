class AddMiscellaneousChargesToVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :miscellaneous_charges, :boolean, default: false
  end
end
