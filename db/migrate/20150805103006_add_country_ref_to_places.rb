class AddCountryRefToPlaces < ActiveRecord::Migration
  def change
    add_reference :places, :country, index: true
  end
end
