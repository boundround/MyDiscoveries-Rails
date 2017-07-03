class AddMiscellaneousLabelsToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :room_type_label, :string, default: ""
    add_column :spree_products, :package_option_label, :string, default: ""
  end
end
