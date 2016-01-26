class RemoveAgesFromPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :minimum_age, :integer
    remove_column :places, :maximum_age, :integer
  end
end
