class RemoveArea < ActiveRecord::Migration
  def change
    drop_table :areas
    drop_table :areas_users
  end
end
