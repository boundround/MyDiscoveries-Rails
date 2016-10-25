class GoodToKnowsController < ApplicationController
  before_action :set_data, except: [:index, :edit]

  def create
    @good_to_know = GoodToKnow.new(good_to_know_params)
    @good_to_know.good_to_knowable_id = @variable.id
    @good_to_know.good_to_knowable_type = @variable.class.to_s


    if @good_to_know.save
      redirect_to :back, notice: "Good To Know Created"
    else
      redirect_to :back, notice: "Sorry, there was an error created your \"Good To Know\"."
    end
  end

  def update
    @good_to_know = GoodToKnow.find(params[:id])
    if @good_to_know.update(good_to_know_params)
      redirect_to eval("#{@path}_good_to_knows_path(@variable, @good_to_know.id)"), notice: "Good To Know Updated"
    else
      render "edit", notice: "Sorry, there was an error updating this video"
    end
  end

  def destroy
    @good_to_know = GoodToKnow.find(params[:id])
    @good_to_know.destroy
    redirect_to eval("#{@path}_good_to_knows_path(@variable, @good_to_know.id)"), notice: "Good To Know Deleted"
  end

  def new
    @place = Place.find(params[:place_id])
    @good_to_know = GoodToKnow.new
    # render :new
  end

  def edit
    if params[:place_id].blank?
      @attraction = Attraction.friendly.find(params[:attraction_id])
    else
      @place = Place.friendly.find(params[:place_id])
    end
    
    @good_to_know = GoodToKnow.find(params[:id])
  end

  def index
    if params[:place_id]
      @place = Place.friendly.find(params[:place_id])
      @good_to_knows = @place.good_to_knows
      @good_to_know = GoodToKnow.new
    elsif params[:attraction_id]
      @attraction = Attraction.friendly.find(params[:attraction_id])
      @good_to_knows = @attraction.good_to_knows
      @good_to_know = GoodToKnow.new
    end

  end

  def set_data
    if params[:place_id]
      @variable = Place.friendly.find(params[:place_id])
      @path = "place"
    elsif params[:attraction_id]
      @variable = Attraction.friendly.find(params[:attraction_id])
      @path = "attraction"
    end
  end

  private
    def good_to_know_params
      params.require(:good_to_know).permit(:description, :show_on_page, :good_to_knowable_id, :good_to_knowable_type)
    end
end
