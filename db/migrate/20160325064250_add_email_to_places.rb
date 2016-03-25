class AddEmailToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :email, :string
  end
end
