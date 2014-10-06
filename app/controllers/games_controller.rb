class GamesController < ApplicationController

  def index
    @games = Game.includes(:place).paginate(:page => params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @games }
    end
  end

  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @game }
    end
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
    if @game.update(game_params)
      redirect_to :back
    end
  end

  def import
    Game.import(params[:file])
    redirect_to :back, notice: "Games imported."
  end

  private

    def game_params
      params.require(:game).permit(:url, :area_id, :place_id, :priority, :game_type)
    end

end
