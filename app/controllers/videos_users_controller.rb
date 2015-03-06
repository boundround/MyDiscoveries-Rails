class VideosUsersController < ApplicationController

  def create
    @videos_user = VideosUser.new(videos_user_params)

    if @videos_user.save
      render nothing: true
    end
  end

  def destroy
    @videos_user = params["videos_user"]
  end

  private
    def videos_user_params
      params.require(:videos_user).permit(:video_id, :user_id)
    end

end
