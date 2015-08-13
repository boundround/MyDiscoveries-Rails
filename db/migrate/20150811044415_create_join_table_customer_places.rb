class CreateJoinTableCustomerPlaces < ActiveRecord::Migration
  def change
    create_table :customers_places do |t|
      t.integer :user_id
      t.integer :place_id
    end
  end
end
