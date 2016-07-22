class CreatePlacesStories < ActiveRecord::Migration
  def change
    create_table :places_stories do |t|
      t.integer :place_id
      t.integer :story_id

      t.timestamps
    end

    add_index :places_stories, [:place_id, :story_id], unique: true
  end
end
