class AddAddAxCustAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ax_cust_account, :string
  end
end
