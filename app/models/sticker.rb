class Sticker < ActiveRecord::Base
  has_many :products_stickers, dependent: :destroy

  has_many :products, through: :products_stickers, class_name: Spree::Product

  mount_uploader :file, StickerUploader
end
