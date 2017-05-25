class AddDepartureDatesToProduct < ActiveRecord::Migration
  def change
  	add_column :spree_products, :departure_dates, :string
  end
end
