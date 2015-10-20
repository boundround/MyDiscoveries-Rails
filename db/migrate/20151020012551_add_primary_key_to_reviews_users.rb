class AddPrimaryKeyToReviewsUsers < ActiveRecord::Migration
  def change
    add_column :reviews_users, :id, :primary_key
  end
end
