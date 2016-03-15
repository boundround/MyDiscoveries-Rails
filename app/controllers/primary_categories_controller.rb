class PrimaryCategoriesController < ApplicationController
	

	def show
	#hardcode #check
	@cat = params[:id] #using on place
	debugger
	@primary_category = PrimaryCategory.find_by_identifier(@cat)
	if !@primary_category.nil?
		@areas = @primary_category.places.is_area
		@places = @primary_category.places.where.not(is_area: true)
	end
	@stories = ApiBlog.get_cached_blogs(@cat,"primary_cat")

	end

	# def wp_blog
 #    	@blog = ApiBlog.find_blog_primary_cat(params[:id].to_i, params[:cat])
 #    	debugger
	# end


end
