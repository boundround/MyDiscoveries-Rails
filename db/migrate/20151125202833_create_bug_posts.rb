class CreateBugPosts < ActiveRecord::Migration
  def change
    create_table :bug_posts do |t|
      t.integer :user_id
      t.text :description
      t.string :screen_shot
      t.string :author
      t.timestamps
    end
  end
end
