class InfoBitsController < ApplicationController
  def index
    @info_bits = InfoBit.all
  end

  def all
    if params[:country_id]
      @country = Country.friendly.find(params[:country_id])
      variable = @country
    end

    @info_bits = variable.info_bits
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
    if params[:country_id]
      @country = Country.friendly.find(params[:country_id])
      variable = @country
    end

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
    if params[:country_id]
      @country = Country.friendly.find(params[:country_id])
      redirect_to all_country_info_bits_path(@country), notice: "info bit deleted"
    else
      redirect_to :back, notice: "info bit deleted"
    end
  end


  private

    def info_bit_params
      params.require(:info_bit).permit(:title, :description, :photo, :photo_credit, :status, :_destroy)
    end
end
