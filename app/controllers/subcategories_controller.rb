class SubcategoriesController < ApplicationController


	def show
  	#hardcode #check
    @cat = params[:id]
  	@subcategory = Subcategory.find_by_identifier(params[:id])
    if !@subcategory.nil?
      @areas = @subcategory.places.is_area
      @places = @subcategory.places.where.not(is_area: true)
    end
    @stories = ApiBlog.get_cached_blogs(@cat,"subcategory")
	end

end
