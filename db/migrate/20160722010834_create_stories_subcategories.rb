class CreateStoriesSubcategories < ActiveRecord::Migration
  def change
    create_table :stories_subcategories do |t|
      t.integer :subcategory_id
      t.integer :story_id

      t.timestamps
    end
    add_index :stories_subcategories, [:story_id, :subcategory_id], unique: true
  end
end
