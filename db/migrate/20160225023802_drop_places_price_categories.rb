class DropPlacesPriceCategories < ActiveRecord::Migration
  def change
    drop_table :places_price_categories
  end
end
