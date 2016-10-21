class CreateStoryImages < ActiveRecord::Migration
  def change
    create_table :story_images do |t|
      t.string :file
      t.integer :story_id
    end
  end
end
