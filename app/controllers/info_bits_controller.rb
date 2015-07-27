class InfoBitsController < ApplicationController
  def index
    @info_bits = InfoBit.all
  end

  def show
    @info_bit = InfoBit.friendly.find(params[:id])
  end

  def new
    @info_bit = InfoBit.new
  end

  def create
    @info_bit = InfoBit.new(info_bit_params)
    if params[:country_id]
      @info_bit.countries << Country.friendly.find(params[:country_id])
    end
    if @info_bit.save
      redirect_to :back, notice: "famous face added."
    else
      render :new
    end
  end

  def edit
    @info_bit = InfoBit.find(params[:id])
  end

  def update
    @info_bit = InfoBit.find(params[:id])
    if @info_bit.update(info_bit_params)
      redirect_to :back
    end
  end

  def destroy
    @info_bit = InfoBit.find(params[:id])
    @info_bit.destroy
    redirect_to :back, notice: "famous face deleted"
  end


  private

    def info_bit_params
      params.require(:info_bit).permit(:title, :description, :photo, :_destroy)
    end
end
