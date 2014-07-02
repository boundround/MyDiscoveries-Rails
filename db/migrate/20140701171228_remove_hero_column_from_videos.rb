class RemoveHeroColumnFromVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :hero, :boolean
  end
end
