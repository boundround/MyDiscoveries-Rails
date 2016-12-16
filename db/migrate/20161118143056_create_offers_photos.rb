class CreateOffersPhotos < ActiveRecord::Migration
  def change
    create_table :offers_photos do |t|
      t.integer :photo_id
      t.integer :offer_id
    end

    add_index :offers_photos, :offer_id
    add_index :offers_photos, [:offer_id, :photo_id], unique: true
  end
end
