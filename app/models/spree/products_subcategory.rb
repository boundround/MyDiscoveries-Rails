class Spree::ProductsSubcategory < ActiveRecord::Base
  belongs_to :product
  belongs_to :subcategory
end
