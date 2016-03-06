class CreateSimilarPlaces < ActiveRecord::Migration
  def change
    create_table :similar_places do |t|
      t.integer :place_id
      t.integer :similar_place_id

      t.timestamps
    end
    add_index :similar_places, :place_id
    add_index :similar_places, :similar_place_id
    add_index :similar_places, [:place_id, :similar_place_id], unique: true
  end
end
