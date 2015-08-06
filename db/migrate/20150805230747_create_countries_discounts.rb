class CreateCountriesDiscounts < ActiveRecord::Migration
  def change
    create_table :countries_discounts do |t|
      t.integer :country_id
      t.integer :discount_id

      t.timestamps
    end
  end
end
