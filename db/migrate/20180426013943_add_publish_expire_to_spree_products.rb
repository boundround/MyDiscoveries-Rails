class AddPublishExpireToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :publishenddate_active, :boolean, default: false
    add_column :spree_products, :publishenddate_status, :string, default: ''
  end
end
