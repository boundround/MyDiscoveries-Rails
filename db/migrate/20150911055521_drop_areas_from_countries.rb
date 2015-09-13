class DropAreasFromCountries < ActiveRecord::Migration
  def change
    remove_column :countries, :area_id
  end
end
