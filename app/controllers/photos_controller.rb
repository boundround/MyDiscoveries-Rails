class PhotosController < ApplicationController

  def index
    @photos = Photo.all
    @featured_places = Photo.limit(3) #task uncompleted
    
    @latest = (Photo.all + UserPhoto.all).sort{|x,y|x.created_at <=> y.created_at} #check #add paginate
    # @popular #task uncompleted

    respond_to do |format|
      format.html
      format.json { render json: @photos }
    end
  end

  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @photo }
    end
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    if params[:country_id]
      @photo.countries << Country.friendly.find(params[:country_id])
    end
    if @photo.save
      redirect_to :back, notice: "Photo added."
    else
      render :new
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to :back, notice: "Photo deleted"
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def update
    @photo = Photo.find(params[:id])

    if @photo.update(photo_params)
      @photo.save
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: @photo }
    end
  end

  def import
    Photo.import(params[:file])
    redirect_to :back, notice: "Photos imported."
  end

  private

    def photo_params
      params.require(:photo).permit(:title, :path, :alt_tag, :credit, :area_id, :place_id, :caption, :caption_source,
                                    :customer_approved, :customer_review, :approved_at, :priority, :hero, :status, :country_include, :_destroy)
    end

end
