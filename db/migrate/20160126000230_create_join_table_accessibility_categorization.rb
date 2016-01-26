class CreateJoinTableAccessibilityCategorization < ActiveRecord::Migration
  def change
    create_join_table :places, :accessibility_categories do |t|
      # t.index [:place_id, :accessibility_category_id]
      # t.index [:accessibility_category_id, :place_id]
    end
  end
end
