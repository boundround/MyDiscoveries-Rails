class CreatePriceCategories < ActiveRecord::Migration
  def change
    create_table :price_categories do |t|
      t.string :name
      t.string :identifier

      t.timestamps
    end
  end
end
