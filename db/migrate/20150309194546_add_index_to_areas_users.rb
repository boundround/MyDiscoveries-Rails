class AddIndexToAreasUsers < ActiveRecord::Migration
  def change
    add_index :areas_users, [:area_id, :user_id], :unique => true
  end
end
