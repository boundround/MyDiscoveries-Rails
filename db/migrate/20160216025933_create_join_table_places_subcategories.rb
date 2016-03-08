class CreateJoinTablePlacesSubcategories < ActiveRecord::Migration
  def change
    create_join_table :places, :subcategories do |t|
      t.index [:place_id, :subcategory_id]
      t.index [:subcategory_id, :place_id]
    end
  end
end
