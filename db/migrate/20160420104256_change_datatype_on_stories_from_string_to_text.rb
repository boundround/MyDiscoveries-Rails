class ChangeDatatypeOnStoriesFromStringToText < ActiveRecord::Migration
  def change
  	change_column :stories, :title, :text, :limit => nil
  	change_column :stories, :content, :text, :limit => nil
  end
end
