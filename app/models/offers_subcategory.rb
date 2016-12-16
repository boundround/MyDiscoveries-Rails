class OffersSubcategory < ActiveRecord::Base
  belongs_to :offer
  belongs_to :subcategory
end
