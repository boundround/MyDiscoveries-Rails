class CreateJoinTableUsersReviews < ActiveRecord::Migration
  def change
    create_join_table :users, :reviews do |t|
      t.index [:user_id, :review_id]
      t.index [:user_id, :review_id]
    end
  end
end
