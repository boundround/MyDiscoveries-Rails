class CategoriesController < ApplicationController
	

	def index
		@categories = PrimaryCategory.all.includes(:places => :subcategories).paginate(per_page: 10, page: params[:page])
	end

	private


end
