class CreatePostsUsers < ActiveRecord::Migration
  def change
    create_table :posts_users do |t|

      t.timestamps
    end
  end
end
