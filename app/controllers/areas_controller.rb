class AreasController < ApplicationController
  def index
    @areas = Area.all
  end

  def show
    @area = Area.find(params[:id])
  end

  def create
    @area = Area.new(area_params)

    if @area.save
      redirect_to(areas_path, notice: 'Area succesfully saved')
    else
      redirect_to 'areas#new'
    end
  end

  def new
    @area = Area.new
    @area.photos.build
  end

  def edit
  end

  def destroy
  end

  private
    def area_params
      params.require(:area).permit(:code, :identifier, :display_name, :country, :short_intro, :description, photos_attributes: [:title, :path, :credit])
    end
end
