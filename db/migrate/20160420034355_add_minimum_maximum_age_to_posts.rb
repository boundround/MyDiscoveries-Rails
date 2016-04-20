class AddMinimumMaximumAgeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :minimum_age, :integer
    add_column :posts, :maximum_age, :integer
  end
end
