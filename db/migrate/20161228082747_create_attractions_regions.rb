class CreateAttractionsRegions < ActiveRecord::Migration
  def change
    create_table :attractions_regions, id: false do |t|
    	t.belongs_to :attraction, index: true
    	t.belongs_to :region, index: true
    end
  end
end
