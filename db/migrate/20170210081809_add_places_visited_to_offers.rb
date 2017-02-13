class AddPlacesVisitedToOffers < ActiveRecord::Migration
  def change
  	add_column :offers, :places_visited, :string, array: true, default: []
  end
end
