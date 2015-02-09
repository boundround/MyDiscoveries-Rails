class PhotosController < ApplicationController

  def index
    @photos = Photo.all

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
      redirect_to :back, notice: "Photo updated"
    end
  end

  def import
    Photo.import(params[:file])
    redirect_to :back, notice: "Photos imported."
  end

  private

    def photo_params
      params.require(:photo).permit(:title, :path, :alt_tag, :credit, :area_id, :place_id, :caption, :caption_source, :priority)
    end

end
