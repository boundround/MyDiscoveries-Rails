class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :title
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :address_one
      t.string :address_two
      t.string :address_three
      t.string :city
      t.string :state
      t.string :postal_code
      t.boolean :is_primary
      t.references :country, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
