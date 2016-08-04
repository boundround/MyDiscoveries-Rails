class AddColumnsToPostsUsers < ActiveRecord::Migration
  def change
    add_column :posts_users, :post_id, :integer
    add_column :posts_users, :user_id, :integer

    add_index :posts_users, [:user_id, :post_id], unique: true
  end
end
