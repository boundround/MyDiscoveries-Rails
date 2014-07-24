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

    if @place.subscription_level == "Premium"
      @videos = @place.videos.where.not(priority: 1)
      @hero_video = @place.videos.find_by(priority: 1)
      @games = @place.games
    else
      @videos = []
      @games = []
    end

    if !@place.photos.find_by(priority: 1)
      @area_hero_video = @place.area.videos.find_by(priority: 1)
    end
    if @area_hero_video
      @area_videos = @place.area.videos.where.not(priority: 1)
    else
      @area_videos = @place.area.videos
    end
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
    @photos = @place.photos
    @photo = Photo.new
    @games = @place.games
    @videos = @place.videos
    @discounts = @place.discounts
    @discount = Discount.new
  end

  def update
    @place = Place.friendly.find(params[:id])

    if @place.update(place_update_params)
      redirect_to :back
    end
  end

  def destroy
  end

  def import
    Place.import(params[:file])
    redirect_to places_path, notice: "Places imported."
  end

  def send_postcard
    name = params[:name]
    email = params[:email]
    message = params[:message]
    photo = params[:photo]
    place = params[:place]
    area = params[:area]
    country = params[:country]
    Share.postcard(name, email, message, photo, place, area, country).deliver
    redirect_to :back, notice: 'Postcard sent'
  end

  private
    def place_params
      params.require(:place).permit(:code, :identifier, :display_name, :description, :subscription_level, :latitude, :longitude, :icon, :map_icon, :passport_icon, :address, :area_id, photos_attributes: [:id, :title, :path, :fun_fact, :credit])
    end

    def place_update_params
      params.require(:place).permit(:display_name, :description, :address, :subscription_level, photo: [:id, :title, :path, :credit, :fun_fact, :area_id])
    end
end
