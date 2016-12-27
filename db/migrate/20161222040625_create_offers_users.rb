class CreateOffersUsers < ActiveRecord::Migration
  def change
    create_table :offers_users do |t|
      t.integer :user_id
      t.integer :offer_id
    end
  end
end
