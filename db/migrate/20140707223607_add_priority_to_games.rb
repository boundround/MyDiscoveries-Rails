class AddPriorityToGames < ActiveRecord::Migration
  def change
    add_column :games, :priority, :integer
  end
end
