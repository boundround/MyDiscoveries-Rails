class CreateDealsUsers < ActiveRecord::Migration
  def change
    create_table :deals_users do |t|
      t.integer :user_id
      t.integer :deal_id
    end
  end
end
