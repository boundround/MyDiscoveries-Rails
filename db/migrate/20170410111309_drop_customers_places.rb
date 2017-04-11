class DropCustomersPlaces < ActiveRecord::Migration
  def change
    drop_table :customers_places
  end
end
