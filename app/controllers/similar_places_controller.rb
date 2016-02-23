class SimilarPlacesController < ApplicationController

  def create
    @similar_places = SimilarPlace.new(similar_places_params)

    if @similar_places.save
      render nothing: true
    end
  end

  def edit
  end

  def index
    @place = Place.friendly.find(params[:place_id])
    @similar_place = SimilarPlace.new
    @areas = Place.active.where("is_area IS true")
  end

  def destroy
    @similar_places = SimilarPlace.find_by(place_id: params["similar_places"]["place_id"], similar_place_id: params["similar_places"]["similar_place_id"])
    @similar_places.destroy
    render nothing: true
  end

  private
    def similar_places_params
      params.require(:similar_places).permit(:place_id, :similar_place_id)
    end

end
