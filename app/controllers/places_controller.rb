class PlacesController < ApplicationController
  def index
    @places = Place.all

    # geojson for MapBox map
    @places_geojson = Place.all_geojson

    respond_to do |format|
      format.html
      format.json { render json: @places_geojson }  # respond with the created JSON object
    end
  end

  def show
    @place = Place.friendly.find(params[:id])
    @photoable = @place
    @photos = @photoable.photos
    @photo = Photo.new

    @request_xhr = request.xhr?

    respond_to do |format|
      format.html { render 'show', :layout => !request.xhr? }
    end
  end

  def create
    @place = Place.new(place_params)

    if @place.save
      redirect_to(places_path, notice: 'Place succesfully saved')
    else
      redirect_to '/places#new', notice: 'Place not saved!'
    end
  end

  def new
    @place = Place.new
    @place.photos.build
    @areas = Area.all
  end

  def edit
    @place = Place.friendly.find(params[:id])
    @areas = Area.all
    @photoable = @place
    @photos = @photoable.photos
    @photo = Photo.new
  end

  def update
    @place = Place.friendly.find(params[:id])

    if @place.update(place_update_params)
      redirect_to :back
    end
  end

  def destroy
  end

  private
    def place_params
      params.require(:place).permit(:code, :identifier, :display_name, :description, :subscription_level, :latitude, :longitude, :icon, :map_icon, :passport_icon, :address, :area_id, photos_attributes: [:id, :title, :path, :fun_fact, :credit])
    end

    def area_update_params
      params.require(:place).permit(:display_name, :description, :address, photo: [:id, :title, :path, :credit, :fun_fact, :area_id])
    end
end
