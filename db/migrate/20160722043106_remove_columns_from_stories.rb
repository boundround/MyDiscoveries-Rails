class RemoveColumnsFromStories < ActiveRecord::Migration
  def change
    remove_column :stories, :country_id
    remove_column :stories, :storiable_id
    remove_column :stories, :storiable_type
  end
end
