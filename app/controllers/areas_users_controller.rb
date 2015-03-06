class AreasUsersController < ApplicationController

  def create
    @areas_user = AreasUser.new(photos_user_params)

    if @areas_user.save
      render nothing: true
    end
  end

  def destroy
    @areas_user = params["photos_user"]
  end

  private
    def areas_user_params
      params.require(:areas_user).permit(:area_id, :user_id)
    end

end
