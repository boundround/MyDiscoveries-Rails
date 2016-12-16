class SubcategoriesController < ApplicationController

  def index
    @subcategories = Subcategory.subcats.includes(:places => :subcategories)
    @subcategories = @subcategories.sort {|x, y| y.places.size <=> x.places.size}
  end

	def show
  	#hardcode #check
    # @more_places.paginate(page: params[:more_places_page], per_page: params[:more_places_page].nil?? 6 : 3 )
    @cat = params[:id]
  	@subcategory = Subcategory.find_by_identifier(params[:id]) || Subcategory.find(params[:id])
    if !@subcategory.nil?
      @places = @subcategory.places.paginate(page: params[:places_page], per_page: params[:places_page].nil?? 6 : 3 )
      @areas = @subcategory.attractions.paginate(page: params[:areas_page], per_page: params[:areas_page].nil?? 6 : 3 )
    end
    # @stories = ApiBlog.get_cached_blogs(@cat,"subcategory")
    @stories = @subcategory.stories.last(3)
    @subcategories = @subcategory.subcategory_related
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
    @subcategories = Subcategory.order(category_type: :asc, name: :asc)
    @subcategory = Subcategory.new
  end

  def edit
    @subcategory = Subcategory.find(params[:id])
    @subcategories = Subcategory.where.not(id: @subcategory).order(name: :asc)
  end

  def update
    @subcategory = Subcategory.find(params[:id])
    params[:subcategory][:related_to].delete("")
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
      @areas= Place.active.includes(:subcategories).order(top_100: :desc).filter(age_ranges_params).paginate page: params[:areas_page], per_page: 3
    end

  private
    def subcategory_params
      params.require(:subcategory).permit(:name, :icon, :primary_description, :secondary_description, :category_type, related_to: [],)
    end

    def age_ranges_params
      if params[:age_ranges].present?
        ranges= params[:age_ranges].split('-')
        return { minimum_age: ranges.first.to_i, maximum_age: ranges.last.to_i } unless ranges.blank?
      end
    end

end
