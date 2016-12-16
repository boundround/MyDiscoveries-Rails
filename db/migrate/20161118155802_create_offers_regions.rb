class CreateOffersRegions < ActiveRecord::Migration
  def change
    create_table :offers_regions do |t|
      t.integer :offer_id
      t.integer :region_id
    end

    add_index :offers_regions, :offer_id
    add_index :offers_regions, [:offer_id, :region_id], unique: true
  end
end
