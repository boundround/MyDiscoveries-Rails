class AddMinAndMaxToUsers < ActiveRecord::Migration
  def change
    add_column :users, :min_age, :integer
    add_column :users, :max_age, :integer
  end
end
