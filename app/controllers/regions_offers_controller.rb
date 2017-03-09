class RegionsOffersController < ApplicationController
  include ApplicationHelper

  def create
    @offer = Spree::Product.friendly.find(params[:offer_id])
    @offer.regions = []
    if params[:regions_offers]
      @regions_ids = params[:regions_offers][:region_ids]
      @regions_ids.each do |id|
        @offer.products_regions.create(product_id: @offer.id, region_id: id)
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
    @regions_offers = @offer.regions.build
    all_regions_offers = @offer.regions
    @regions = destination_available(Region.all, all_regions_offers)
  end

  def destroy
    @regions_offer = Spree::ProductsRegion.find_by(product_id: params["regions_offers"]["offer_id"], region_id: params["regions_offers"]["region_id"])
    @regions_offer.destroy
    render nothing: true
  end
end
