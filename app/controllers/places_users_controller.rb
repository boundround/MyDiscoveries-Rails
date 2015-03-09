class PlacesUsersController < ApplicationController

  def create
    @places_user = PlacesUser.new(places_user_params)

    if @places_user.save
      render nothing: true
    end
  end

  def destroy
    @places_user = PlacesUser.find_by(place_id: params["places_user"]["place_id"], user_id: params["places_user"]["user_id"])
    @places_user.destroy
    render nothing: true
  end

  private
    def places_user_params
      params.require(:places_user).permit(:place_id, :user_id)
    end

end
