class AreasController < ApplicationController
  # before_action :authenticate_user!, :only => [:new, :edit, :create, :destroy]

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

    respond_to do |format|
      format.html { render 'show', :layout => !request.xhr? }
      format.json
    end

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

    @area = Area.find(params[:id])

  end


  def update

    @area = Area.find(params[:id])

    if @area.update(area_update_params)
      redirect_to areas_path
    end

  end

  def destroy
  end

  def mercury_update
    area = Area.find(params[:id])
    area.description = params[:content]['area-content'][:value]
    area.save!
    photo = Photo.find(params[:content]['photo-id'][:value])
    photo.fun_fact = params[:content]['fun-fact-text'][:value]
    photo.save!
    render text: ""
  end


  private
    def area_params
      params.require(:area).permit(:code, :identifier, :display_name, :country, :short_intro, :description, :latitude, :longitude, :address, photos_attributes: [:id, :title, :path, :credit])
    end

    def area_update_params
      params.require(:area).permit(:display_name, :short_intro, :description, :address, photo: [:id, :title, :path, :credit, :area_id])
    end

    def verify_admin
      (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
    end
end
