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
    @three_d_video = ThreeDVideo.find(params[:id])
    # @place = Place.friendly.find(params[:place_id])
    if @three_d_video.update(three_d_video_params)
      redirect_to :back, notice: "3D Video Updated"
      # redirect_to place_three_d_videos_path(@place), notice: "3D Video Updated"
    else
      render "edit", notice: "Sorry, there was an error updating this video"
    end
  end

  def destroy
    @place = Place.friendly.find(params[:place_id])
    @three_d_video = ThreeDVideo.find(params[:id])
    @three_d_video.destroy
    redirect_to place_three_d_videos_path(@place), notice: "3D Video Deleted"
  end

  def new
    @place = Place.find(params[:place_id])
    @three_d_video = ThreeDVideo.new
    # render :new
  end

  def edit
    @three_d_video = ThreeDVideo.find(params[:id])
    @place = Place.friendly.find(params[:place_id])
  end

  def index
    if params[:place_id]
      # @three_d_videos = Place.three_d_videos.find(params[:place_id]).three_d_videos
      @place = Place.friendly.find(params[:place_id])
      @three_d_videos = @place.three_d_videos
      @three_d_video = ThreeDVideo.new
      # @place.three_d_videos = ThreeDVideo.all
    elsif params[:attraction_id]
      # @three_d_videos = Place.three_d_videos.find(params[:place_id]).three_d_videos
      @attraction = Attraction.friendly.find(params[:attraction_id])
      @three_d_videos = @attraction.three_d_videos
      @three_d_video = ThreeDVideo.new
      # @place.three_d_videos = ThreeDVideo.all
    end

  end


  private
    def three_d_video_params
      params.require(:three_d_video).permit(:link, :caption, :place_id)
    end
end
