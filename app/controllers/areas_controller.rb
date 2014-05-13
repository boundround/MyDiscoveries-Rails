class AreasController < ApplicationController
  def index
    @areas = Area.all
  end

  def show
    @area = Area.find(params[:id])
  end

  def create
    @area = Area.new
  end

  def new
    @area = Area.new
    @photo = Photo.new
  end

  def edit
  end

  def destroy
  end

  private
    def areas_params
      params.require(:area).permit!
    end
end
