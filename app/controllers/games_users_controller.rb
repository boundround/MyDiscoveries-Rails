class GamesUsersController < ApplicationController

  def create
    @games_user = GamesUser.new(games_user_params)

    if @games_user.save
      render nothing: true
    end
  end

  def destroy
    @games_user = params["games_user"]
  end

  private
    def games_user_params
      params.require(:games_user).permit(:game_id, :user_id)
    end

end
