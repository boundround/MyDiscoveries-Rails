class UserPhotosUsersController < ApplicationController

  def create
    @user_photos_user = UserPhotosUser.new(user_photos_user_params)

    if @user_photos_user.save
      render nothing: true
    end
  end

  def destroy
    @user_photos_user = UserPhotosUser.find_by(story_id: params["user_photos_user"]["user_photo_id"], user_id: params["user_photos_user"]["user_id"])
    @user_photos_user.destroy
    render nothing: true
  end

  private
    def user_photos_user_params
      params.require(:user_photos_user).permit(:user_photo_id, :user_id)
    end

end
