class PrimaryCategoriesController < ApplicationController

	before_action :category, only: [:show]
	before_action :stories, only: [:show] #get stories

	def show
		@areas= category.places.is_area.paginate(per_page: 10, page: params[:areas_page])
		@places= category.places.is_not_area.paginate(per_page: 6, page: params[:places_page])
	end

	def index
	end

	def new
		@primary_category = PrimaryCategory.new
	end

	def create
		@primary_category = PrimaryCategory.new(primary_category_params)

		if @primary_category.save
      redirect_to :back, notice: "Primary Category added."
    else
      render :new
    end
	end

	def cms_index
		@primary_categories = PrimaryCategory.all
		@primary_category = PrimaryCategory.new
	end

	def edit
		@primary_category = PrimaryCategory.find(params[:id])
	end

	def update
		@primary_category = PrimaryCategory.find(params[:id])

		if @primary_category.update(primary_category_params)
			redirect_to :back, notice: "#{@primary_category.name} updated"
		else
			redirect_to primary_category_edit_path(@primary_category), notice: "Sorry there was an error saving your changes"
		end
	end

	def destroy
		@primary_category = PrimaryCategory.find(params[:id])
		@primary_category.destroy
		redirect_to :back, notice: "Primary Category Deleted"
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

		def primary_category_params
      params.require(:primary_category).permit(:name, :icon)
    end

end
