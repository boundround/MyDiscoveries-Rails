class GamesController < ApplicationController

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to :back, notice: "Game added."
    else
      render :new
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to :back, notice: "Game deleted"
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    if @game.update(photo_params)
      redirect_to :back
    end
  end

  def import
    Game.import(params[:file])
    redirect_to :back, notice: "Games imported."
  end

  private

    def game_params
      params.require(:game).permit(:url, :area_id, :place_id, :priority)
    end

end
