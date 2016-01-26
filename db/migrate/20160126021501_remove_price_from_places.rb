class RemovePriceFromPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :price_category, :integer
  end
end
