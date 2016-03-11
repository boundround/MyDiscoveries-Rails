class SubCategoriesController < ApplicationController
	

	def show
	#hardcode #check
	@sub_category = PlacesSubcategory.find_by_identifier(params[:id])
	end


end
