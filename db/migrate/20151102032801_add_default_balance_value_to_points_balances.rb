class AddDefaultBalanceValueToPointsBalances < ActiveRecord::Migration
  def up
    change_column :points_balances, :balance, :integer, :default => 0
  end

  def down
    change_column :points_balances, :balance, :integer, :default => nil
  end
end
