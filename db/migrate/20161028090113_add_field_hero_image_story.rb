class AddFieldHeroImageStory < ActiveRecord::Migration
  def change
    add_column :stories, :hero_image, :string
  end
end
