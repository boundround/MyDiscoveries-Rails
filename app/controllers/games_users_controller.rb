class GamesUsersController < ApplicationController

  def create
    @games_user = GamesUser.new(games_user_params)

    if @games_user.save
      render nothing: true
    end
  end

  def destroy
    @games_user = GamesUser.find_by(game_id: params["games_user"]["game_id"], user_id: params["games_user"]["user_id"])
    @games_user.destroy
    render nothing: true
  end

  private
    def games_user_params
      params.require(:games_user).permit(:game_id, :user_id)
    end

end
