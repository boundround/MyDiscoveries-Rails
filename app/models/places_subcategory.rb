class PlacesSubcategory < ActiveRecord::Base

	belongs_to :place
	belongs_to :subcategory

end
