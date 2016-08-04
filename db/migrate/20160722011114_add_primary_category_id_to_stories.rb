class AddPrimaryCategoryIdToStories < ActiveRecord::Migration
  def change
    add_column :stories, :primary_category_id, :integer
    add_index :stories, :primary_category_id
  end
end
