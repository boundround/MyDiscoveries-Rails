class CreatePassengers < ActiveRecord::Migration
  def change
    create_table :passengers do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :telephone
      t.string :mobile
      t.string :email
      t.integer :order_id

      t.timestamps
    end

    add_index :passengers, :order_id
  end
end
