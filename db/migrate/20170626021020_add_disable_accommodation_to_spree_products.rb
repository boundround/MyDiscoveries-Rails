class AddDisableAccommodationToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :disable_accommodation, :boolean, default: false
  end
end
