class AddUserAndTitleToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :user_id, :integer
    add_column :reviews, :title, :string
  end
end
