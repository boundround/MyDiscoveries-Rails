class AddInstructionsColumnToGames < ActiveRecord::Migration
  def change
    add_column :games, :instructions, :string
  end
end
