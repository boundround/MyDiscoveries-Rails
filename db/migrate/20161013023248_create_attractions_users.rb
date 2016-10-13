class CreateAttractionsUsers < ActiveRecord::Migration
  def change
    create_table :attractions_users do |t|
      t.integer :user_id
      t.integer :attraction_id
    end
  end
end
