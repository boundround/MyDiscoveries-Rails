class RemoveHeroImageFromStories < ActiveRecord::Migration
  def change
    remove_column :stories, :hero_image, :string
  end
end
