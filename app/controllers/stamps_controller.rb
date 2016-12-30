class StampsController < ApplicationController

  def new
    @stamp = Stamp.new
  end

  def create
    @stamp = Stamp.new(stamp_params)
    @place = Place.friendly.find(params[:place_id])
    if @stamp.save
      redirect_to place_stamps_path(@place)
    else
      render action: "new"
    end
  end

  def destroy
    @stamp = Stamp.find(params[:id])
    @stamp.destroy
    redirect_to :back, notice: "Stamp deleted"
  end

  def show
    @stamp = Stamp.find(params[:id])
      render action: "show"
  end

  def edit
    @stamp = Stamp.find(params[:id])
    @place = Place.friendly.find(params[:place_id])
  end

  def update
    @stamp = Stamp.find(params[:id])
    @place = Place.friendly.find(params[:place_id])
    if @stamp.update(stamp_params)
      @stamp.save
      redirect_to place_stamps_path(@place)
    end
  end

  def index
    @place = Place.friendly.find(params[:place_id])
    @stamps = @place.stamps
    @stamp = Stamp.new
  end

  def new_transaction
    @stamp = Stamp.new
  end

  private
    def stamp_params
      params.require(:stamp).permit(:serial, :place_id)
    end
end


