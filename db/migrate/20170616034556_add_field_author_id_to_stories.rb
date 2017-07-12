class AddFieldAuthorIdToStories < ActiveRecord::Migration
  def change
  	add_column :stories, :author_id, :integer
  end
end
