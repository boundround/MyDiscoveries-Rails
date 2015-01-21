class AddIndexToPlaces < ActiveRecord::Migration
  def change
    add_index :places, :display_name
  end
end
