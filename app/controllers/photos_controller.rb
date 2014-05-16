class PhotosController < ApplicationController
  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.save
  end

  def destroy
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.update(photo_params)
      redirect_to 'areas#index'
    end
  end


  private

    def photo_params
      params.require(:photo).permit(:title, :path, :credit, :area_id, :id)
    end


end
