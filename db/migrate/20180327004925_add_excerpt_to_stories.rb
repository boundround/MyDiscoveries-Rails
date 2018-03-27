class AddExcerptToStories < ActiveRecord::Migration
  def change
    add_column :stories, :excerpt, :text, default: ""
  end
end
