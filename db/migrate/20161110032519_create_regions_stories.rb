class CreateRegionsStories < ActiveRecord::Migration
  def change
    create_table :regions_stories do |t|
      t.integer :region_id
      t.integer :story_id

      t.timestamps
    end
  end
end
