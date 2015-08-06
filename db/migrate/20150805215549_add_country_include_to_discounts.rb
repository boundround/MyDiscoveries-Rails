class AddCountryIncludeToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :country_include, :boolean
  end
end
