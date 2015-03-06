class AddPrimaryKeyToPlacesUsers < ActiveRecord::Migration
  def change
    add_column :places_users, :id, :primary_key
  end
end
