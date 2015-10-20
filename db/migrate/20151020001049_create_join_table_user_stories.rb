class CreateJoinTableUserStories < ActiveRecord::Migration
  def change
    create_join_table :users, :stories do |t|
      t.index [:user_id, :story_id]
      t.index [:story_id, :user_id]
    end
  end
end
