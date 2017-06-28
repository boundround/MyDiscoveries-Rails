class AddDisableDepartureDateToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :disable_departure_date, :boolean, default: false
  end
end
