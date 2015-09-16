class AddTitleAndDescriptionToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :title, :string
    add_column :videos, :description, :text
  end
end
