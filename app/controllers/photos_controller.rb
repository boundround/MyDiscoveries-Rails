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
      redirect_to areas_path
    end
  end

  def import
    Photo.import(params[:file])
    redirect_to areas_path, notice: "Photos imported."
  end

  private

    def photo_params
      params.require(:photo).permit(:title, :path, :credit, :area_id, :fun_fact, :id)
    end


end
