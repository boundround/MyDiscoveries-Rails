class AddNumbersToOffers < ActiveRecord::Migration
  def change
  	add_column :offers, :number_of_days, :integer	
  	add_column :offers, :number_of_nights, :integer	
  end
end
