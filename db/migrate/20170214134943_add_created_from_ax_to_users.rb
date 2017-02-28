class AddCreatedFromAxToUsers < ActiveRecord::Migration
  def change
    add_column :users, :created_from_ax, :boolean, default: false
  end
end
