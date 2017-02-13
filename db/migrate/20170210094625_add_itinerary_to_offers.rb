class AddItineraryToOffers < ActiveRecord::Migration
  def change
  	add_column :offers, :itinerary, :string
  end
end
