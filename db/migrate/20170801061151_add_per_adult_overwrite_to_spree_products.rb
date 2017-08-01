class AddPerAdultOverwriteToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :per_adult_overwrite, :string, default: ""
  end
end
