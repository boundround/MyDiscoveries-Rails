class AttractionsOffersController < ApplicationController

  def create
    @offer = Spree::Product.friendly.find(params[:offer_id])
    @offer.attractions = []
    if params[:attractions_offers]
      @attractions_ids = params[:attractions_offers][:attraction_ids]
      @attractions_ids.each do |id|
        @offer.products_attractions.create(product_id: @offer.id, attraction_id: id)
      end
    end

    redirect_to :back
  end

  def edit;end

  def update
    @offer = Spree::Product.friendly.find(params[:offer_id])
  end

  def index
    @offer = Spree::Product.friendly.find(params[:offer_id])
    @attractions_offers = @offer.attractions.build
    @attractions = Attraction.active.order(display_name: :asc)
  end

  def destroy
    @offers_attractions = Spree::ProductsAttraction.find_by(product_id: params["attractions_offers"]["offer_id"], attraction_id: params["attractions_offers"]["attraction_id"])
    @offers_attractions.destroy
    render nothing: true
  end
end
