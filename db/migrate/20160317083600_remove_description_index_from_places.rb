class RemoveDescriptionIndexFromPlaces < ActiveRecord::Migration
  def change
    remove_index :places, :name => 'index_places_on_description'
  end
end
