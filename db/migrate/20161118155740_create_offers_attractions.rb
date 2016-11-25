class CreateOffersAttractions < ActiveRecord::Migration
  def change
    create_table :offers_attractions do |t|
      t.integer :offer_id
      t.integer :attraction_id
    end

    add_index :offers_attractions, :offer_id
    add_index :offers_attractions, [:offer_id, :attraction_id], unique: true        
  end
end
