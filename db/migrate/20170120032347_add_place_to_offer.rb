class AddPlaceToOffer < ActiveRecord::Migration
  def change
  	add_reference :offers, :place, index: true
  end
end
