class Spree::ProductsCountry < ActiveRecord::Base
  belongs_to :product
  belongs_to :country
end
