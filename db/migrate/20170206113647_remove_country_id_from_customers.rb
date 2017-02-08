class RemoveCountryIdFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :country_id
  end
end
