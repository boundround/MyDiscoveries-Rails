class AddStoryPriorityToUserPhotos < ActiveRecord::Migration
  def change
    add_column :user_photos, :story_priority, :integer
  end
end
