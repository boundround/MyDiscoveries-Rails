class GoodToKnowsController < ApplicationController
  def create
    @good_to_know = GoodToKnow.new(good_to_know_params)
    @place = Place.friendly.find(params[:place_id])
    @good_to_know.good_to_knowable_id = @place.id
    @good_to_know.good_to_knowable_type = @place.class.to_s


    if @good_to_know.save
      redirect_to :back, notice: "Good To Know Created"
    else
      redirect_to :back, notice: "Sorry, there was an error created your \"Good To Know\"."
    end
  end

  def update
    @good_to_know = GoodToKnow.find(params[:id])
    @place = Place.friendly.find(params[:place_id])
    if @good_to_know.update(good_to_know_params)
      redirect_to place_good_to_knows_path(@place), notice: "Good To Know Updated"
    else
      render "edit", notice: "Sorry, there was an error updating this video"
    end
  end

  def destroy
    @place = Place.friendly.find(params[:place_id])
    @good_to_know = GoodToKnow.find(params[:id])
    @good_to_know.destroy
    redirect_to place_good_to_knows_path(@place), notice: "Good To Know Deleted"
  end

  def new
    @place = Place.find(params[:place_id])
    @good_to_know = GoodToKnow.new
    # render :new
  end

  def edit
    @good_to_know = GoodToKnow.find(params[:id])
    @place = Place.friendly.find(params[:place_id])
  end

  def index
    if params[:place_id]
      # @good_to_knows = Place.good_to_knows.find(params[:place_id]).good_to_knows
      @place = Place.friendly.find(params[:place_id])
      @good_to_knows = @place.good_to_knows
      @good_to_know = GoodToKnow.new
      # @place.good_to_knows = GoodToKnow.all
    end

  end


  private
    def good_to_know_params
      params.require(:good_to_know).permit(:description, :show_on_page, :good_to_knowable_id, :good_to_knowable_type)
    end
end
