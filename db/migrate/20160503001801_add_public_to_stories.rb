class AddPublicToStories < ActiveRecord::Migration
  def change
    add_column :stories, :public, :boolean
  end
end
