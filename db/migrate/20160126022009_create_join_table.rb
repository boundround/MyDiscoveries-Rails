class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :places, :price_categories do |t|
      t.index [:place_id, :price_category_id]
      t.index [:price_category_id, :place_id]
    end
  end
end
