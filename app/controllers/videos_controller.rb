class VideosController < ApplicationController
  def index
    # @videos = Video.ordered_by_place_name.paginate(:page => params[:page])
    @videos = Video.includes(:place => :area).order('areas.display_name ASC, places.display_name ASC').paginate(:page => params[:page])
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    response = Unirest.get "http://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/" + @video.vimeo_id.to_s
    @video.vimeo_thumbnail = response.body["thumbnail_url"]
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
      response = Unirest.get "http://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/" + @video.vimeo_id.to_s
      @video.vimeo_thumbnail = response.body["thumbnail_url"]
      @video.save
      redirect_to :back
    end
  end

  def import
    Video.import(params[:file])
    redirect_to :back, notice: "Videos imported."
  end

  private

    def video_params
      params.require(:video).permit(:vimeo_id, :area_id, :place_id, :priority, :vimeo_thumbnail)
    end

end
