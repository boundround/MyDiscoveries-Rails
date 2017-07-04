class AddVoucherBookingEssentialsToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :voucher_booking_essentials, :text, default: ""
  end
end
