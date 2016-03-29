class AddPrivateProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_private, :boolean, default: true
  end
end
