class AddAreaIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :area_id, :integer
  end
end
