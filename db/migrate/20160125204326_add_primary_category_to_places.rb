class AddPrimaryCategoryToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :primary_category, :string, default: ""
  end
end
