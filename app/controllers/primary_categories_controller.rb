class PrimaryCategoriesController < ApplicationController
	

	def show
	#hardcode #check
	@primary_category = PrimaryCategory.find_by_identifier(params[:id])
	@places = @primary_category.places

	end


end
