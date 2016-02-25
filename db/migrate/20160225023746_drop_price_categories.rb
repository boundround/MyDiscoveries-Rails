class DropPriceCategories < ActiveRecord::Migration
  def change
    drop_table :price_categories
  end
end
