class Spree::ProductsPlace < ActiveRecord::Base
  belongs_to :product
  belongs_to :place
end
