# This migration comes from spree_add_on (originally 20130903205515)
class AddExpirationDaysToAddOns < ActiveRecord::Migration
  def change
    add_column :spree_add_ons, :expiration_days, :integer, default: nil
  end
end
