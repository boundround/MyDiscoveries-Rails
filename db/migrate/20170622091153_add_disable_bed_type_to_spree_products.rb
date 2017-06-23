class AddDisableBedTypeToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :disable_bed_type, :boolean, default: false
  end
end
