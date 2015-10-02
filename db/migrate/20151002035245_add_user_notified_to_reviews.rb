class AddUserNotifiedToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :user_notified, :boolean
    add_column :reviews, :user_notified_at, :datetime
  end
end
