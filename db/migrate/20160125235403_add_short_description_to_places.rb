class AddShortDescriptionToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :meta_description, :text
  end
end
