class CreateBestTimeToVisitCategories < ActiveRecord::Migration
  def change
    create_table :best_time_to_visit_categories do |t|
      t.string :name
      t.string :identifier

      t.timestamps
    end
  end
end
