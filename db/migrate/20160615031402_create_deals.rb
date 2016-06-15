class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :url
      t.string :hero_image
      t.string :description
      t.integer :min_price
      t.integer :dealable_id
      t.string :dealable_type

      t.timestamps
    end
    add_index :deals, [:dealable_id, :dealable_type]
  end
end
