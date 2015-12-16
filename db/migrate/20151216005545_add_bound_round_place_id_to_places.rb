class AddBoundRoundPlaceIdToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :bound_round_place_id, :string
    add_index :places, :bound_round_place_id, unique: true
  end
end
