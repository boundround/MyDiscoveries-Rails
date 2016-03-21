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

  private
    def subcategory_params
      params.require(:subcategory).permit(:name, :icon)
    end

end
