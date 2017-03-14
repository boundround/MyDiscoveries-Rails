class AddBookingEssentialsToOperator < ActiveRecord::Migration
  def change
  	add_column :operators, :booking_essentials, :text
  end
end
