class AddPrimaryKeyToStoriesUsers < ActiveRecord::Migration
  def change
    add_column :stories_users, :id, :primary_key
  end
end
