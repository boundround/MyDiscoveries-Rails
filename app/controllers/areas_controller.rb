class AreasController < ApplicationController
  def index
    @areas = Area.all
  end

  def show
    @area = Area.find(params[:id])
  end

  def create
    @area = Area.new(area_params)
    @photo = @area.photos.build
    @area.save
    @photo.save

  end

  def new
    @area = Area.new
    @photo = @area.photos.build
  end

  def edit
  end

  def destroy
  end

  private
    def area_params
      params.require(:area).permit(:code, :identifier, :country, :display_name, :short_intro, :description, photo_attributes: [:title, :credit, :path])
    end
end
