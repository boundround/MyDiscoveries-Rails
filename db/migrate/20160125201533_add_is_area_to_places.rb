class AddIsAreaToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :is_area?, :boolean
  end
end
