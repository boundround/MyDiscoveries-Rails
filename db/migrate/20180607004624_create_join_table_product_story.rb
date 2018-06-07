class CreateJoinTableProductStory < ActiveRecord::Migration
  def change
    create_join_table :products, :stories  do |t|
      t.index [:story_id, :product_id]
      t.index [:product_id, :story_id]

      t.belongs_to :product, index: true
      t.belongs_to :story, index: true
    end
  end
end
