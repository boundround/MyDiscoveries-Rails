class CreateCreateAttractionsPosts < ActiveRecord::Migration
  def change
    create_table :attractions_posts do |t|
      t.integer   :place_id
      t.integer   :post_id
    end
  end
end
