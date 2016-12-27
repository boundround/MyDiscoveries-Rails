class CountriesOffersController < ApplicationController

  def create
    @offer = Offer.find(params[:offer_id])
    @offer.countries = []
    if params[:countries_offer]
      @countries_ids = params[:countries_offer][:country_ids]
      @countries_ids.each do |id|
        @offer.offers_countries.create(offer_id: @offer.id, country_id: id)
      end
    end
    debugger
    redirect_to :back
  end

  def edit;end

  def update
    @offer = Offer.find(params[:offer_id])
  end

  def index
    @offer = Offer.find(params[:offer_id])
    @countries_offers = @offer.countries.build
    @countries = Country.order(display_name: :asc)
  end

  def destroy
    @offers_countries = OffersCountry.find_by(offer_id: params["countries_offer"]["offer_id"], place_id: params["countries_offer"]["country_id"])
    @offers_countries.destroy
    render nothing: true
  end

  private
    def attractions_stories_params
      params.require(:attractions_stories).permit(:story_id, :attraction_ids => [])
    end

end