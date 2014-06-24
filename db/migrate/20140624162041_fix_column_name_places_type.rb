class FixColumnNamePlacesType < ActiveRecord::Migration
  def change
    rename_column :places, :type, :subscription_level
  end
end
