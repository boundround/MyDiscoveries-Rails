class CreateJoinTableSecondaryCategorization < ActiveRecord::Migration
  def change
    create_join_table :places, :secondary_categories do |t|
      t.index [:place_id, :secondary_category_id], name: "place_categories"
      t.index [:secondary_category_id, :place_id], name: "category_places"
    end
  end
end
