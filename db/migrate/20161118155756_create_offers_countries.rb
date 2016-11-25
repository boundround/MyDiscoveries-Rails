class CreateOffersCountries < ActiveRecord::Migration
  def change
    create_table :offers_countries do |t|
      t.integer :offer_id
      t.integer :country_id
    end

    add_index :offers_countries, :offer_id
    add_index :offers_countries, [:offer_id, :country_id], unique: true                
  end
end
