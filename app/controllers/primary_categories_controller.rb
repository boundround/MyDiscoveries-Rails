class PrimaryCategoriesController < ApplicationController
	
	before_action :category, only: [:show]

	def show
		@areas= category.places.is_area.paginate(per_page: 10, page: params[:areas_page])
		@places= category.places.is_not_area.paginate(per_page: 1, page: params[:places_page])
	end

	private 

		def category
			@category ||= PrimaryCategory.includes(:places => :stories).find_by_identifier(params[:id])
			raise ActiveRecord::RecordNotFound if @category.nil?
			@category
		end

		def stories
			@stories ||= ApiBlog.get_cached_blogs(params[:id], "primary_cat")
		end


end
