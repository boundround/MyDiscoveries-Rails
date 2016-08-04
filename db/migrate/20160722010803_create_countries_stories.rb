class CreateCountriesStories < ActiveRecord::Migration
  def change
    create_table :countries_stories do |t|
      t.integer :country_id
      t.integer :story_id

      t.timestamps
    end
    add_index :countries_stories, [:country_id, :story_id], unique: true
  end
end
