class CreateCustomersAttractions < ActiveRecord::Migration
  def change
    create_table :customers_attractions do |t|
      t.integer :user_id
      t.integer :attraction_id
    end
  end
end
