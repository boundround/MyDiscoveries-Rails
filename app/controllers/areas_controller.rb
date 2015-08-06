class AreasController < ApplicationController
  # before_action :redirect_if_not_admin, :except => [:show, :mapdata, :default_serializer_options, :search]

  def index
    @areas = Area.all

    respond_to do |format|
      format.html
      format.json { render json: @areas }  # respond with the created JSON object
    end
  end

  def search
    @areas = Area.where("display_name @@ :q", q: params[:term])

    respond_to do |format|
      format.json { render json: @areas.to_json }  # respond with the created JSON object
    end
  end

  def show
    @area = Area.includes(:videos, :games, :photos, :discounts, :fun_facts, places: [:photos, :games, :videos, :categories]).friendly.find(params[:id])
    @hero_video = @area.videos.find_by(priority: 1)
    @hero_photo = @area.photos.find_by(priority: 1)
    @photos = @area.photos.where.not(priority: 1)
    @videos = @area.videos.where.not(priority: 1)
    @request_xhr = request.xhr?
    @fun_facts = @area.fun_facts

    respond_to do |format|
      format.html { render 'show', :layout => !request.xhr? }
      format.json { render json: @area}
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
    @photos = @area.photos
    @photo = Photo.new
    @games = @area.games
    @videos = @area.videos
    @discounts = @area.discounts
    @discount = Discount.new

  end


  def update

    @area = Area.friendly.find(params[:id])

    if @area.update(area_params)
      @area = Area.find(@area.id)
      redirect_to edit_area_path(@area), notice: 'Area succesfully updated'
    end

  end

  def destroy

  end

  def mapdata

    # geojson for MapBox map
    @geojson = Area.all_geojson

    respond_to do |format|
      format.html
      format.json { render json: @geojson }  # respond with the created JSON object
    end
  end

  def import
    Area.import(params[:file])
    redirect_to areas_path, notice: "Areas imported."
  end

  def default_serializer_options
    {root: false}
  end

  private
    def area_params
      params.require(:area).permit(:code, :identifier, :display_name, :country, :short_intro, :description,
                                    :latitude, :longitude, :address, :published_status, :view_latitude, :view_longitude,
                                    :view_height, :view_heading,
                                    photos_attributes: [:id, :area_id, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :status, :country_include, :_destroy],
                                    videos_attributes: [:id, :vimeo_id, :priority, :place_id, :area_id, :status, :country_include, :_destroy],
                                    games_attributes: [:id, :url, :area_id, :place_id, :priority, :game_type, :status, :_destroy],
                                    fun_facts_attributes: [:id, :content, :reference, :priority, :area_id, :place_id, :status, :country_include, :_destroy],
                                    discounts_attributes: [:id, :description, :place_id, :area_id, :status, :country_include, :_destroy])
    end

end
