class CreateJoinTableDurationCategoryPlaces < ActiveRecord::Migration
  def change
    create_join_table :places, :duration_categories do |t|
      # t.index [:place_id, :duration_category_id]
      # t.index [:duration_category_id, :place_id]
    end
  end
end
