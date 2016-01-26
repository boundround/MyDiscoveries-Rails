class AccessibilityCategoriesPlace < ActiveRecord::Base
  belongs_to :accessibility_category
  belongs_to :place
end
