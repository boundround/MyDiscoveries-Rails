class CreatePointsBalances < ActiveRecord::Migration
  def change
    create_table :points_balances do |t|
      t.references :user, index: true
      t.integer :balance

      t.timestamps
    end
  end
end
