class ShipsController < ApplicationController
  before_action :set_ship, only: [:show, :edit, :update, :destroy]

  def index
    @ships = Ship.all
  end

  def show;end

  def new
    @ship = Ship.new
  end

  def edit;end

  def create
    @ship = Ship.new(ship_params)

    if @ship.save
      redirect_to(ships_path, notice: 'Ship was successfully created')
    else
      flash.now[:alert] = 'Ship not saved!'
      render :new
    end
  end

  def update
    if @ship.update(ship_params)
      redirect_to edit_ship_path(@ship), notice: "Ship was successfully updated"
    else
      flash.now[:alert] = 'Sorry, there was an error updating this Ship'
      render :edit
    end
  end

  def destroy
    @ship.destroy
    redirect_to ships_path, notice: "Ship Deleted"
  end

  private
  def set_ship
    @ship = Ship.friendly.find(params[:id])
  end

  def ship_params
    params.require(:ship).permit(:name, :slug, :cruise_line, :overview, :facilities, :map)
  end
end
