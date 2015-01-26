class AddBookingLinkToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :booking_url, :string
  end
end
