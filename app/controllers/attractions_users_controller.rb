class AttractionsUsersController < ApplicationController

  def create
    @attractions_user = AttractionsUser.new(attractions_user_params)

    if @attractions_user.save
      render nothing: true
    end
  end

  def destroy
    @attractions_user = AttractionsUser.find_by(attraction_id: params["attractions_user"]["attraction_id"], user_id: params["attractions_user"]["user_id"])
    @attractions_user.destroy
    render nothing: true
  end

  private
    def attractions_user_params
      params.require(:attractions_user).permit(:attraction_id, :user_id)
    end

end
