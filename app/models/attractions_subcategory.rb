class AttractionsSubcategory < ActiveRecord::Base

  belongs_to :attraction
  belongs_to :subcategory
end
