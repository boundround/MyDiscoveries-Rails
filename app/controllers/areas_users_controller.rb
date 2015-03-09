class AreasUsersController < ApplicationController

  def create
    @areas_user = AreasUser.new(areas_user_params)

    if @areas_user.save
      render nothing: true
    end
  end

  def destroy
    @areas_user = AreasUser.find_by(area_id: params["areas_user"]["area_id"], user_id: params["areas_user"]["user_id"])
    @areas_user.destroy
    render nothing: true
  end

  private
    def areas_user_params
      params.require(:areas_user).permit(:area_id, :user_id)
    end

end
