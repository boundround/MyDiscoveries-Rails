class DropDealsUsers < ActiveRecord::Migration
  def change
    drop_table :deals_users
  end
end
