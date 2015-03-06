class AddPrimaryKeyToAreasUsers < ActiveRecord::Migration
  def change
    add_column :areas_users, :id, :primary_key
  end
end
