class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user, index: true
      t.string :asset_type
      t.integer :points
      t.text :comments

      t.timestamps
    end
  end
end
