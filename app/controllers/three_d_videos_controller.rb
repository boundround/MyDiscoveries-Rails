class ThreeDVideosController < ApplicationController

  def create
    @three_d_video = ThreeDVideo.new(three_d_video_params)

    if @three_d_video.save
      redirect_to :back, notice: "3D Video Created"
    else
      redirect_to :back, notice: "Sorry, there was an error created your Video."
    end
  end

  def update
    @three_d_videos = ThreeDVideo.find(params[:id])
    if @three_d_videos.update(three_d_video_params)
      redirect_to :back
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: @three_d_videos }
    end
  end

  def destroy
    @three_d_video = ThreeDVideo.find(params[:id])
    @three_d_video.destroy
    redirect_to :back, notice: "3D Video deleted"
  end

  def new
    @place = Place.find(params[:place_id])
    @three_d_video = ThreeDVideo.new
    # render :new
  end

  def index
    if params[:place_id]
      # @three_d_videos = Place.three_d_videos.find(params[:place_id]).three_d_videos
      @place = Place.find(params[:place_id])
      @three_d_videos = @place.three_d_videos
      # @place.three_d_videos = ThreeDVideo.all
    end

  end


  private
    def three_d_video_params
      params.require(:three_d_video).permit(:link, :caption, :place_id)
    end
end
