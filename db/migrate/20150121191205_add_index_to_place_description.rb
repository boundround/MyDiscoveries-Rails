class AddIndexToPlaceDescription < ActiveRecord::Migration
  def change
    add_index :places, :description
  end
end
