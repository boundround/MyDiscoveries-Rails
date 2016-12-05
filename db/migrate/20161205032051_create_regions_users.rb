class CreateRegionsUsers < ActiveRecord::Migration
  def change
    create_table :regions_users do |t|
      t.integer :user_id
      t.integer :region_id
    end
  end
end