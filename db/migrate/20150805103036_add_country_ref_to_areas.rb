class AddCountryRefToAreas < ActiveRecord::Migration
  def change
    add_reference :areas, :country, index: true
  end
end
