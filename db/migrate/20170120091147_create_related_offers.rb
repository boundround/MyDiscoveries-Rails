class CreateRelatedOffers < ActiveRecord::Migration
  def change
    create_table :related_offers do |t|
      t.integer :offer_id
      t.integer :related_offer_id

      t.timestamps
    end
  end
end
