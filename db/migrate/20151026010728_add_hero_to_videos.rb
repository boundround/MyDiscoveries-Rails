class AddHeroToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :hero, :boolean
  end
end
