class AddDisableDepartureCityToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :disable_departure_city, :boolean, default: false
  end
end
