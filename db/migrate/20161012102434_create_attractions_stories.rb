class CreateAttractionsStories < ActiveRecord::Migration
  def change
    create_table :attractions_stories do |t|

      t.timestamps
    end
  end
end
