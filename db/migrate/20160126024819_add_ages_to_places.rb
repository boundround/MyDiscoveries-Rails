class AddAgesToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :minimum_age, :integer
    add_column :places, :maximum_age, :integer
  end
end
