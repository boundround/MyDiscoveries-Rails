class AddIndexToGamesUsers < ActiveRecord::Migration
  def change
    add_index :games_users, [:game_id, :user_id], :unique => true
  end
end
