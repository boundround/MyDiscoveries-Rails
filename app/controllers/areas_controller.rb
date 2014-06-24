class AreasController < ApplicationController

  # before_filter :verify_admin, :only => [:new, :edit, :create, :destroy]


  def index
    @areas = Area.all

    # geojson for MapBox map
    @geojson = Area.all_geojson

    respond_to do |format|
      format.html
      format.json { render json: @geojson }  # respond with the created JSON object
    end
  end

  def show
    @area = Area.friendly.find(params[:id])
    @video = @area.video
    @request_xhr = request.xhr?

    respond_to do |format|
      format.html { render 'show', :layout => !request.xhr? }
    end

  end

  def create
    @area = Area.new(area_params)

    if @area.save
      redirect_to(areas_path, notice: 'Area succesfully saved')
    else
      redirect_to '/areas#new', notice: 'Area not saved!'
    end
  end

  def new
    @area = Area.new
    @area.photos.build
  end

  def edit

    @area = Area.friendly.find(params[:id])


  end


  def update

    @area = Area.friendly.find(params[:id])

    if @area.update(area_update_params)
      redirect_to :back
    end

  end

  def destroy

  end

  def import
    Area.import(params[:file])
    redirect_to areas_path, notice: "Areas imported."
  end

  private
    def area_params
      params.require(:area).permit(:code, :identifier, :display_name, :country, :short_intro, :description, :latitude, :longitude, :address, photos_attributes: [:id, :title, :path, :fun_fact, :credit])
    end

    def area_update_params
      params.require(:area).permit(:display_name, :short_intro, :description, :address, photo: [:id, :title, :path, :credit, :fun_fact, :area_id])
    end

end
