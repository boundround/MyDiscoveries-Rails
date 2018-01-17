class AddStoryTypesToStories < ActiveRecord::Migration
  def change
    story_type = StoryType.create(name: "What's On")
    add_reference :stories, :story_type, index: true

    Story.update_all story_type_id: story_type.id  
  end
end
