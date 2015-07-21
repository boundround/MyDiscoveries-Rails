class AddUserCreatedToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :user_created, :boolean
    add_column :places, :created_by, :string
  end
end
