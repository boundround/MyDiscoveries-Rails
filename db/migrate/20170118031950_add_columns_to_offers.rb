class AddColumnsToOffers < ActiveRecord::Migration
  def change
  	add_column :offers, :validityStartDate, :date
  	add_column :offers, :validityEndDate, :date
  	add_column :offers, :publishStartDate, :date
  	add_column :offers, :publishEndDate, :date
  end
end
