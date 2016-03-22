class SubcategoriesController < ApplicationController

  def index
  end

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

  def new
    @subcategory = Subcategory.new
  end

  def create
    @subcategory = Subcategory.new(subcategory_params)

    if @subcategory.save
      redirect_to :back, notice: "Subcategory added."
    else
      render :new
    end
  end

  def cms_index
    @subcategories = Subcategory.order(category_type: :asc)
    @subcategory = Subcategory.new
  end

  def edit
    @subcategory = Subcategory.find(params[:id])
  end

  def update
    @subcategory = Subcategory.find(params[:id])

    if @subcategory.update(subcategory_params)
      redirect_to :back, notice: "#{@subcategory.name} updated"
    else
      redirect_to subcategory_edit_path(@subcategory), notice: "Sorry there was an error saving your changes"
    end
  end

  def destroy
    @subcategory = Subcategory.find(params[:id])
    @subcategory.destroy
    redirect_to :back, notice: "Primary Category Deleted"
  end

  def specific
      @areas= Place.filter(age_ranges_params).paginate page: params[:areas_page], per_page: 2
    end

  private
    def subcategory_params
      params.require(:subcategory).permit(:name, :icon)
    end

    def age_ranges_params
      if params[:age_ranges].present?
        ranges= params[:age_ranges].split('-')
        return { min_age: ranges.first.to_i, max_age: ranges.last.to_i } unless ranges.blank?
      end
    end

end
