class CreateOffersPlaces < ActiveRecord::Migration
  def change
    create_table :offers_places do |t|
      t.integer :offer_id
      t.integer :place_id
    end

    add_index :offers_places, :offer_id
    add_index :offers_places, [:offer_id, :place_id], unique: true            
  end
end
