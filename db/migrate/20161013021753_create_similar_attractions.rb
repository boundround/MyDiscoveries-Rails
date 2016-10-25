class CreateSimilarAttractions < ActiveRecord::Migration
  def change
    create_table :similar_attractions do |t|
      t.integer :attraction_id
      t.integer :similar_place_id
      
      t.timestamps
    end
  end
end
