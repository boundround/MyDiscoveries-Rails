class Spree::ProductsPhoto < ActiveRecord::Base
  belongs_to :product
  belongs_to :photo
end
