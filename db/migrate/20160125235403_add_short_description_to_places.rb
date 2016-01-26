class AddShortDescriptionToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :short_description, :text
  end
end
