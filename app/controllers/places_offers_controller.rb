class PlacesOffersController < ApplicationController
  include ApplicationHelper

  def create
    @offer = Offer.friendly.find(params[:offer_id])
    @offer.places = []
    if params[:places_offers]
      @places_ids = params[:places_offers][:place_ids]
      @places_ids.each do |id|
        @offer.offers_places.create(offer_id: @offer.id, place_id: id)
      end
    end

    redirect_to :back
  end

  def edit;end

  def update
    @offer = Offer.friendly.find(params[:offer_id])
  end

  def index
    @offer = Offer.friendly.find(params[:offer_id])
    @places_offers = @offer.places.build
    all_places_offers = @offer.places
    @places = destination_available(Place.active.where(is_area: true), all_places_offers)
  end

  def destroy
    @offers_places = OffersPlace.find_by(offer_id: params["places_offers"]["offer_id"], place_id: params["places_offers"]["place_id"])
    @offers_places.destroy
    render nothing: true
  end

  private
    def attractions_stories_params
      params.require(:attractions_stories).permit(:story_id, :attraction_ids => [])
    end

end