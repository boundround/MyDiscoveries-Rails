class AddSeoColumnsToStories < ActiveRecord::Migration
  def change
    add_column :stories, :focus_keyword, :text
    add_column :stories, :seo_title, :text
  end
end
