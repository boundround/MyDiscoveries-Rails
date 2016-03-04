class SimilarPlacesController < ApplicationController

  def create
    @place = Place.find_by_slug(params[:place_id])
    @place.similar_places = []
    if params[:similar_place]
      @similar_place_ids = params[:similar_place][:similar_place_ids]
      @similar_place_ids.each do |id|
        @place.similar_places.create(place_id: @place.id, similar_place_id: id)
      end
    end

    redirect_to :back

  end

  def edit
  end

  def update
    @place = Place.find_by_slug(params[:place_id])
  end

  def index
    @place = Place.friendly.find(params[:place_id])
    @similar_places = @place.similar_places.build
    @areas = Place.active.where(is_area: true)
  end

  def destroy
    @similar_place = SimilarPlace.find_by(place_id: params["similar_places"]["place_id"], similar_place_id: params["similar_places"]["similar_place_id"])
    @similar_place.destroy
    render nothing: true
  end

  private
    def similar_places_params
      params.require(:similar_place).permit(:place_id, :similar_place_ids => [])
    end

end
