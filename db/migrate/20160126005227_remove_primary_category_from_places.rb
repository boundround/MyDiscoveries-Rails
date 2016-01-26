class RemovePrimaryCategoryFromPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :primary_category, :string
  end
end
