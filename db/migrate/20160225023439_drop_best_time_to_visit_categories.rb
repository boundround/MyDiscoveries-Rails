class DropBestTimeToVisitCategories < ActiveRecord::Migration
  def change
    drop_table :best_time_to_visit_categories
  end
end
