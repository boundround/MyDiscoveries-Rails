# This migration comes from spree_add_on (originally 20130905175944)
class AddPriceAndExpirationDateToLineItemAddOn < ActiveRecord::Migration
  def change
    add_column :spree_line_item_add_ons, :price, :decimal, precision: 8, scale: 2
    add_column :spree_line_item_add_ons, :expiration_date, :datetime
  end
end
