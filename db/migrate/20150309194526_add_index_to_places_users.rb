class AddIndexToPlacesUsers < ActiveRecord::Migration
  def change
    add_index :places_users, [:place_id, :user_id], :unique => true
  end
end
