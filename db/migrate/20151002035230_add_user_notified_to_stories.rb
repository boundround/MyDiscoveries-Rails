class AddUserNotifiedToStories < ActiveRecord::Migration
  def change
    add_column :stories, :user_notified, :boolean
    add_column :stories, :user_notified_at, :datetime
  end
end
