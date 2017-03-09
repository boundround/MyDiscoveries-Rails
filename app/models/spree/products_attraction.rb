class Spree::ProductsAttraction < ActiveRecord::Base
  belongs_to :product
  belongs_to :attraction
end
