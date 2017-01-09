class CreateAttractionsPlaces < ActiveRecord::Migration
  def change
    create_table :attractions_places, id: false do |t|
    	t.belongs_to :attraction, index: true
    	t.belongs_to :place, index: true
    end
  end
end
