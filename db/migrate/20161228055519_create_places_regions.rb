class CreatePlacesRegions < ActiveRecord::Migration
  def change
    create_table :places_regions, id: false do |t|
    	t.belongs_to :place, index: true
    	t.belongs_to :region, index: true
    end
  end
end
