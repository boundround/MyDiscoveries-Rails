class CreateJoinTableBestTimeToVisitCategoriesPlaces < ActiveRecord::Migration
  def change
    create_join_table :places, :best_time_to_visit_categories do |t|
      t.index [:place_id, :best_time_to_visit_category_id], name: "best_time_place"
      t.index [:best_time_to_visit_category_id, :place_id], name: "place_best_time"
    end
  end
end
