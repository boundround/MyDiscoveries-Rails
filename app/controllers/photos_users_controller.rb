class PhotosUsersController < ApplicationController

  def create
    @photos_user = PhotosUser.new(photos_user_params)

    if @photos_user.save
      render nothing: true
    end
  end

  def destroy
    @photos_user = params["photos_user"]
  end

  private
    def photos_user_params
      params.require(:photos_user).permit(:photo_id, :user_id)
    end

end
