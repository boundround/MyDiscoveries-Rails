class CountriesController < ApplicationController

  def index
    @countries = Country.all
  end

  def show
    @country = Country.friendly.find(params[:id])
    if @country.capital_city
      @weather = OpenWeather::Current.city("#{@country.capital_city}, #{@country.country_code}")
      @weather_time = Time.at(@weather["dt"]).strftime("%I:%M%p")
      @weather_description = @weather["weather"][0]["description"]
      @weather_temp = (@weather["main"]["temp"] - 273.15).to_i.to_s
    end
  end

  def edit
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
      params.require(:country).permit(:display_name, :country_code, :description, :capital_city, :short_name, :long_name,
                      :capital_city_description, :currency_code, :official_language, :tallest_mountain,
                      :tallest_mountain_height, :longest_river, :longest_river_length, :published_status, :hero_photo, :photo_credit,
                      photos_attributes: [:id, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :_destroy],
                      videos_attributes: [:id, :vimeo_id, :priority, :_destroy],
                      fun_facts_attributes: [:id, :content, :reference, :priority, :hero_photo, :_destroy],
                      famous_faces_attributes: [:id, :name, :description, :photo, :photo_credit, :_destroy],
                      info_bits_attributes: [:id, :title, :description, :photo, :photo_credit, :_destroy])
    end
end
