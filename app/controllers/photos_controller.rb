class PhotosController < ApplicationController

  # before_filter :load_photoable

  def index
    @photos = @photoable.photos
  end

  def new
    @photo = @photoable.photos.new
  end

  def create
    @photo = @photoable.photos.new(photo_params)
    if @photo.save
      redirect_to @photoable, notice: "Photo added."
    else
      render :new
    end
  end

  def destroy
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.update(photo_params)
      redirect_to :back
    end
  end

  def import
    Photo.import(params[:file])
    redirect_to :back, notice: "Photos imported."
  end

  private

    def photo_params
      params.require(:photo).permit(:title, :path, :credit, :photoable_id, :photoable_type, :fun_fact, :id)
    end

    # def load_photoable
    #   resource, id = request.path.split('/')[1,2]
    #   @photoable = resource.singularize.classify.constantize.friendly.find(id)
    # end

end
