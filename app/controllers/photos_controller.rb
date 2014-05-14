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


  private

    def photo_params
      params.require(:photo).permit(:title, :path, :credit, :area_id)
    end

end
