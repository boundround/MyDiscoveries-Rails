class AddThumbUrlToGames < ActiveRecord::Migration
  def change
    add_column :games, :thumbnail_url, :string
  end
end
