class GamesController < ApplicationController
  def import
    Game.import(params[:file])
    redirect_to :back, notice: "Games imported."
  end
end
