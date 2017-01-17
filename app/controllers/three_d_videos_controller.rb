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
    if @three_d_video.update(three_d_video_params)
      redirect_to :back, notice: "3D Video Updated"
    else
      render "edit", notice: "Sorry, there was an error updating this video"
    end
  end

  def destroy
    if params[:attraction_id].blank?
      @place = Place.friendly.find(params[:place_id])
      idd = @place
      pathh = 'place'
    else
      @attraction = Attraction.friendly.find(params[:attraction_id])
      idd = @attraction
      pathh = 'attraction'
    end
    
    @three_d_video = ThreeDVideo.find(params[:id])
    @three_d_video.destroy
    redirect_to eval("#{pathh}_three_d_videos_path(idd)"), notice: "3D Video Deleted"
  end

  def new
    @place = Place.find(params[:place_id])
    @three_d_video = ThreeDVideo.new
  end

  def edit
    @three_d_video = ThreeDVideo.find(params[:id])
    if params[:attraction_id].blank?
      @place = Place.friendly.find(params[:place_id])
    else
      @attraction = Attraction.friendly.find(params[:attraction_id])
    end
  end

  def index
    if params[:place_id]
      @place = Place.friendly.find(params[:place_id])
      @three_d_videos = @place.three_d_videos
      @three_d_video = ThreeDVideo.new
    elsif params[:attraction_id]
      @attraction = Attraction.friendly.find(params[:attraction_id])
      @three_d_videos = @attraction.three_d_videos
      @three_d_video = ThreeDVideo.new
    end

  end


  private
    def three_d_video_params
      params.require(:three_d_video).permit(:link, :caption, :place_id, :attraction_id, :three_d_videoable_id, :three_d_videoable_type)
    end
end
