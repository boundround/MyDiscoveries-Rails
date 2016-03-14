class CategoriesController < ApplicationController
	

	def index
	#hardcode #check
	#task : These will be created from PrimaryCategory.all and Subcategory.all
	# Each will click through to an "<@primary_category.places>" page or a "Place.where(subcategory: params[:subcategory])
	# page (single primary category page OR single subcategory page)
	
		@categories = PrimaryCategory.all.includes(:places => :subcategories).paginate(per_page: 10, page: params[:page])
	end

	private


end
