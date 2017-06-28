class CreateJoinTableProductSticker < ActiveRecord::Migration
  def change
    create_join_table :products, :stickers  do |t|
      t.index [:sticker_id, :product_id]
      t.index [:product_id, :sticker_id]

      t.belongs_to :product, index: true
      t.belongs_to :sticker, index: true
    end
  end
end
