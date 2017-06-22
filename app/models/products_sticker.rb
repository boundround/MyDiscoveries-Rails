class ProductsSticker < ActiveRecord::Base
  belongs_to :product, :foreign_key => :product_id
  belongs_to :sticker, :foreign_key => :sticker_id
end
