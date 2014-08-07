class VideosController < ApplicationController
  def index
    @videos = Video.all
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      redirect_to :back, notice: "Video added."
    else
      render :new
    end
  end

  def destroy
  end

  def edit
    @video = Video.find(params[:id])
  end

  def update
    @video = Video.find(params[:id])
    if @video.update(photo_params)
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
