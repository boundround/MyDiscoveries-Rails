class CreateOffersSubcategories < ActiveRecord::Migration
  def change
    create_table :offers_subcategories do |t|
      t.integer :offer_id
      t.integer :subcategory_id
    end

    add_index :offers_subcategories, :offer_id
    add_index :offers_subcategories, [:offer_id, :subcategory_id], unique: true
  end
end
