class PlacesUsersController < ApplicationController

  def create
    @places_user = PlacesUser.new(places_user_params)

    if @places_user.save
      render nothing: true
    end
  end

  def destroy
    @places_user = params["places_user"]
  end

  private
    def places_user_params
      params.require(:places_user).permit(:place_id, :user_id)
    end

end
