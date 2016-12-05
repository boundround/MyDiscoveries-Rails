class GamesController < ApplicationController

  def index
    @games = Game.includes(:place => [:area, :photos]).order('areas.display_name ASC, places.display_name ASC').paginate(:page => params[:page])

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
      @game.add_instructions
      @game.save
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
      @game.add_instructions unless !@game.instructions
      @game.save
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: @game }
    end
  end

  def import
    Game.import(params[:file])
    redirect_to :back, notice: "Games imported."
  end

  private

    def game_params
      params.require(:game).permit(:url, :area_id, :place_id, :priority, :game_type, :status, :customer_approved, :customer_review, :approved_at, :_destroy)
    end

end
