class ChangeColumnDefaultsOnStories < ActiveRecord::Migration
  def change
    change_column_default(:stories, :title, "")
    change_column_default(:stories, :content, "")
  end
end
