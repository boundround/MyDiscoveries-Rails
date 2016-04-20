class CreatePostsSubcategoriesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :posts, :subcategories do |t|
      t.index [:post_id, :subcategory_id]
      t.index [:subcategory_id, :post_id]
    end
  end
end
