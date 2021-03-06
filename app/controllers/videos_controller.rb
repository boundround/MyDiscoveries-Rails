class VideosController < ApplicationController
  def index
    @latest_videos = Video.active.order(:created_at => :desc).where('vimeo_id is not null').paginate(:page => params[:latest_videos_page], per_page: 6)
    respond_to do |f|
      f.html
      f.js
    end
  end

  def all
    if params[:place_id]
      @place = Place.friendly.find(params[:place_id])
      variable = @place
    elsif params[:attraction_id]
      @attraction = Attraction.friendly.find(params[:attraction_id])
      variable = @attraction
    elsif params[:region_id]
      @region = Region.friendly.find(params[:region_id])
      variable = @region
    elsif params[:country_id]
      @country = Country.friendly.find(params[:country_id])
      variable = @country
    elsif params[:offer_id]
      @offer = Spree::Product.friendly.find(params[:offer_id])
      variable = @offer
    end
    @videos = variable.videos
  end

  def show
    @video = Video.find(params["id"])
    key = "bearer " + ENV["VIMEO_OAUTH_KEY"]
    response = Unirest.get "https://api.vimeo.com/videos/" + @video.vimeo_id.to_s, headers: { "Authorization" => key }
    @video_link = response.body
    @no_nav = true

    respond_to do |format|
      format.html
      format.json { render json: @video }
    end
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    if !params["video"]["vimeo_id"].blank?
        response = Unirest.get("https://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/" + @video.vimeo_id.to_s) rescue nil
        @video.youtube_id = ""
    elsif !params["video"]["youtube_id"].blank?
        response = Unirest.get("http://www.youtube.com/oembed?url=http://www.youtube.com/watch?v=#{@video.youtube_id}&format=json") rescue nil
    end

    if response
      @video.vimeo_thumbnail = response.body["thumbnail_url"]
      @video.title = response.body["title"] if @video.title.blank?
      @video.description = response.body["description"] if @video.description.blank?
    end

    if params[:country_id]
      @video.countries << Country.friendly.find(params[:country_id])
    end

    if params[:offer_id]
      @video.products << Spree::Product.friendly.find(params[:offer_id])
    end

    if @video.save
      redirect_to :back, notice: "Video added."
    else
      redirect_to :back, notice: "There was an error saving your video."
    end
  end

  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    redirect_to :back, notice: "Video deleted."
  end

  def edit
    @video = Video.find(params[:id])
  end

  def update
    @video = Video.find(params[:id])
    if @video.update(video_params)
      if !params["video"]["vimeo_id"].blank?
        response = Unirest.get("https://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/" + @video.vimeo_id.to_s) rescue nil
        @video.youtube_id = ""
      elsif !params["video"]["youtube_id"].blank?
        response = Unirest.get("http://www.youtube.com/oembed?url=http://www.youtube.com/watch?v=#{@video.youtube_id}&format=json") rescue nil
      end

      if response
        @video.vimeo_thumbnail = response.body["thumbnail_url"]
        @video.title = response.body["title"] if @video.title.blank?
        @video.description = response.body["description"] if @video.description.blank?
      end
      @video.save
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: @video }
    end
  end

  def import
    Video.import(params[:file])
    redirect_to :back, notice: "Videos imported."
  end

  private

    def video_params
      params.require(:video).permit(:vimeo_id, :transcript, :youtube_id, :title, :hero, :description, :country_id, :place_id, :attraction_id, :videoable_id, :videoable_type, :priority, :vimeo_thumbnail, :status, :country_include, :customer_approved, :customer_review, :approved_at, :_destroy, :youtube_id)
    end

end
