class PlacesController < ApplicationController
  before_action :redirect_if_not_admin, :except => [:show, :send_postcard, :mapdata, :search]

  def index
    @places = Place.all
    @areas = Area.all

    respond_to do |format|
      format.html
      format.json { render json: @places }  # respond with the created JSON object
    end
  end

  def search
    @places = Place.where.not(subscription_level: ['out', 'draft'])
             .text_search(params[:term]).includes(:area)

    # @places = Place.where("display_name @@ :q or description @@ :q", q: params[:term])
    @areas = Area.where("display_name @@ :q", q: params[:term])

    @places = ActiveSupport::JSON.decode(@places.to_json(include: :area))

    @areas = ActiveSupport::JSON.decode(@areas.to_json)

    both = @areas + @places

    respond_to do |format|
      format.json { render json: both.to_json}  # respond with the created JSON object
    end
  end

  def show
    @place = Place.includes(:games, :photos, :videos).friendly.find(params[:id])
    @area = Area.includes(places: [:photos, :games, :videos, :categories]).find(@place.area_id)

    if @place.subscription_level == "Premium"
      @videos = @place.videos.where.not(priority: 1) || []
      @hero_video = @place.videos.find_by(priority: 1)
    else
      @videos = []
    end

    if !@hero_video
      @hero_photo = @place.photos.find_by(priority: 1)
      @photos = @place.photos.where.not(priority: 1)
    else
      @photos = @place.photos
    end

    @area_videos = @place.area.videos
    @request_xhr = request.xhr?

    respond_to do |format|
      format.html { render 'show', :layout => !request.xhr? }
      format.json { render json: @place }
    end
  end

  def create
    @place = Place.new(place_params)

    if @place.identifier == ''
      @place.identifier = @place.display_name.gsub(/\W/, '').downcase
    end

    if @place.save
      JournalInfo.create(place_id: @place.id)
      redirect_to :back, notice: 'Place succesfully saved'
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
      @place = Place.find(@place.id)
      redirect_to edit_place_path(@place), notice: 'Place succesfully updated'
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

  def mapdata

    # geojson for MapBox map
    @places_geojson = Place.all_geojson

    respond_to do |format|
      format.html
      format.json { render json: @places_geojson }  # respond with the created JSON object
    end
  end

  private
    def place_params
      params.require(:place).permit(:code, :identifier, :display_name, :description, :booking_url, :display_address, :subscription_level,
                                    :latitude, :longitude, :logo, :phone_number, :website, :booking_url, :icon, :map_icon,
                                    :passport_icon, :address, :area_id, photos_attributes: [:place_id, :title,
                                      :path, :caption, :alt_tag, :credit, :caption_source, :priority], category_ids: [])
    end

    def place_update_params
      params.require(:place).permit(:display_name, :description, :address, :phone_number, :booking_url, :display_address, :website, :booking_url, :logo,
                                    :map_icon, :area_id, :latitude, :longitude, :subscription_level, photo: [:title, :path, :credit,
                                      :caption, :place_id, :alt_tag, :caption_source, :priority], category_ids: [])
    end
end
