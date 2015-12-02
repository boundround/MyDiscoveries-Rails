class CountriesController < ApplicationController

  def index
    @countries = Country.all
  end

  def show
    @set_body_class = "br-body"
    @country = Country.friendly.find(params[:id])

    @videos_photos = @country.videos
    @videos_photos += @country.photos
    
    @videos = @country.videos
    @photos = @country.photos

    # if @country.capital_city
    #   @weather = OpenWeather::Current.city("#{@country.capital_city}, #{@country.country_code}")
    #   # @weather_time = @weather["dt"] ? Time.at(@weather["dt"]).strftime("%I:%M%p") : nil
    #   @weather_description = @weather["weather"] ? @weather["weather"][0]["description"] : nil
    #   @weather_temp = @weather["main"] ? (@weather["main"]["temp"] - 273.15).to_i.to_s : nil
    # end
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

  def destroy
  end

  private
    def country_params
      params.require(:country).permit(:display_name, :country_code, :description, :capital_city, :short_name, :long_name, :address,
                      :capital_city_description, :currency_code, :official_language, :tallest_mountain, :latitude, :longitude, :google_place_id,
                      :tallest_mountain_height, :longest_river, :longest_river_length, :published_status, :hero_photo, :photo_credit,
                      photos_attributes: [:id, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :status, :country_include, :_destroy],
                      videos_attributes: [:id, :vimeo_id, :priority, :status, :country_include, :_destroy],
                      fun_facts_attributes: [:id, :content, :reference, :priority, :hero_photo, :photo_credit, :status, :country_include, :_destroy],
                      famous_faces_attributes: [:id, :name, :description, :photo, :photo_credit, :status, :_destroy],
                      info_bits_attributes: [:id, :title, :description, :photo, :photo_credit, :status, :_destroy])
    end
end
