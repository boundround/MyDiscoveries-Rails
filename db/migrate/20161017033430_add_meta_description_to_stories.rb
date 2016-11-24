class AddMetaDescriptionToStories < ActiveRecord::Migration
  def change
    add_column :stories, :meta_description, :text
  end
end
