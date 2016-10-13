class CreateAttractionsStories < ActiveRecord::Migration
  def change
    create_table :attractions_stories do |t|
      t.integer :attraction_id
      t.integer :story_id
      
      t.timestamps
    end
  end
end
