class AddPrimaryCategoryFkToPlaces < ActiveRecord::Migration
  def change
    add_reference :places, :primary_category, index: true
  end
end
