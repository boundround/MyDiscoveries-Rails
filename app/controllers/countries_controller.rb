class CountriesController < ApplicationController
  before_action :set_cache_control_headers, only: [:index, :show]
  before_action :find_country_by_slug, only: [:show]

  def index
    @countries = Country.all
    set_surrogate_key_header Country.table_key, @countries.map(&:record_key)
  end

  def show
    @reviews = @country.reviews.where(status:"live")
    @fun_facts = @country.fun_facts.where(status: "live")
    @similar_places = @country.places.primary_areas_with_photos
    @famous_faces = @country.famous_faces.active
    @last_video = @country.videos.active.last
    @photos = @country.country_photos.paginate(:page => params[:active_photos], per_page: 4)
    @photos_hero = @photos.first(6)
    @areas = @similar_places.paginate(page: params[:areas_page], per_page: 6)
    @videos = @country.videos.paginate(:page => params[:active_videos], per_page: 4)
    @stories = @country.country_stories.paginate(page: params[:stories_page], per_page: 4)
    @set_body_class = "destination-page"
  end

  def edit
    @set_body_class = "br-body"
    @country = Country.friendly.find(params[:id])
    @photo = Photo.new
  end

  def new
    @country = Country.new
  end

  def create
    @country = Country.new(country_params)

    if @country.save
      redirect_to(countries_path, notice: 'Country succesfully saved')
    else
      redirect_to '/countries#new', notice: 'Country not saved!'
    end
  end

  def update
    @country = Country.friendly.find(params[:id])

    if @country.update(country_params)
      @country = Country.find(@country.id)
      redirect_to edit_country_path(@country), notice: 'Country succesfully updated'
    end
  end

  def import
    Country.import(params[:file])
    redirect_to countries_path, notice: "Countries imported."
  end

  def destroy;end

  def paginate_videos
    @country = Country.includes(:photos, :places).friendly.find(params[:id])
    @videos = @country.videos.paginate(:page => params[:active_videos], per_page: 4)
  end

  def paginate_photos
    @country = Country.includes(:photos, :places).friendly.find(params[:id])
    @photos = @country.country_photos.paginate(:page => params[:active_photos], per_page: 4)
  end

  def paginate_stories
    @country = Country.friendly.find(params[:id])
    @stories = @country.posts.active
    @stories += @country.stories.active
    @stories = @stories.sort{|x, y| y.created_at <=> x.created_at}.paginate(page: params[:stories_page], per_page: 4)
  end

  def paginate_things_to_do
    @country = Country.friendly.find(params[:id])
    @similar_places = @country.places.primary_areas_with_photos
    @areas = @similar_places.paginate(page: params[:areas_page], per_page: 6 )
  end

  def paginate_deals
    @country = Country.friendly.find(params[:id])
    @deals = @country.deals.active.paginate(:page => params[:active_photos], per_page: 4)
  end

  private
    def country_params
      params.require(:country).permit(:display_name, :country_code, :description, :capital_city, :short_name, :long_name, :address,
                      :capital_city_description, :currency_code, :official_language, :tallest_mountain, :latitude, :longitude, :google_place_id,
                      :tallest_mountain_height, :longest_river, :longest_river_length, :published_status, :hero_photo, :photo_credit,
                      photos_attributes: [:id, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :status, :country_hero, :country_include, :_destroy],
                      videos_attributes: [:id, :vimeo_id, :title, :description, :priority, :status, :country_include, :_destroy],
                      fun_facts_attributes: [:id, :content, :reference, :priority, :hero_photo, :photo_credit, :status, :country_include, :_destroy],
                      famous_faces_attributes: [:id, :name, :description, :photo, :photo_credit, :status, :_destroy],
                      info_bits_attributes: [:id, :title, :description, :photo, :photo_credit, :status, :_destroy])
    end

    def find_country_by_slug
      @country = Country.includes(:photos, :places).friendly.find(params[:id])
      if request.path != country_path(@country)
        redirect_to @country, :status => :moved_permanently
      end
    end
end
