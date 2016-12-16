class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :offer_id
      t.integer :user_id
      t.string  :title
      t.integer :number_of_children, default: 0
      t.integer :number_of_adults, default: 0
      t.integer :number_of_infants, default: 0
      t.integer :total_price, default: 0
      t.date    :start_date

      t.timestamps
    end

    add_index :orders, [:offer_id, :user_id]
  end
end
