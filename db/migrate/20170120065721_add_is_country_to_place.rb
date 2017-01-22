class AddIsCountryToPlace < ActiveRecord::Migration
  def change
  	add_column :places, :is_country, :boolean, default: false
  end
end
