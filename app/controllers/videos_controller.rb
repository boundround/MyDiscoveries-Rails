class VideosController < ApplicationController
  def index
    # @videos = Video.ordered_by_place_name.paginate(:page => params[:page])
#    @videos = Video.includes(:place => :area).order('areas.display_name ASC, places.display_name ASC').paginate(:page => params[:page])
#    @videos = Video.includes(:place => :area).order('places.display_name ASC, areas.display_name ASC').paginate(:page => params[:page])
    if params[:place_id]
      @videos = Place.friendly.find(params[:place_id]).videos
      @place = Place.friendly.find(params[:place_id])
    else
      @videos = Video.includes(:place => :area).order('areas.display_name ASC, places.display_name ASC').paginate(:page => params[:page])
    end
  end

  def show
    @video = Video.find(params["id"])
    key = "bearer " + ENV["VIMEO_OAUTH_KEY"]
    response = Unirest.get "https://api.vimeo.com/videos/" + @video.vimeo_id.to_s, headers: { "Authorization" => key }
    @video_link = response.body
    @no_mobile_nav = true
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

    if @video.save
      redirect_to :back, notice: "Video added."
    else
      render :new
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
      response = Unirest.get "https://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/" + @video.vimeo_id.to_s
      @video.vimeo_thumbnail = response.body["thumbnail_url"]
      if @video.title.blank?
      @video.title = response.body["title"]
      end
      if @video.description.blank?
        @video.description = response.body["description"]
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
      params.require(:video).permit(:vimeo_id, :area_id, :transcript, :youtube_id, :title, :hero, :description, :place_id, :priority, :vimeo_thumbnail, :status, :country_include, :customer_approved, :customer_review, :approved_at, :_destroy, :youtube_id)
    end

end
