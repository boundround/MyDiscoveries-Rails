class AddFeaturedToStories < ActiveRecord::Migration
  def change
  	add_column :stories, :featured, :boolean, default: false
  end
end
