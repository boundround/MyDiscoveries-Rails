class RelatedOffersController < ApplicationController
  include ApplicationHelper

  def create
    @offer = Spree::Product.friendly.find(params[:offer_id])
    @offer.related_products = []
    if params[:related_offer]
      @related_offer_ids = params[:related_offer][:related_offer_ids]
      @related_offer_ids.each do |id|
        @offer.related_products.create(spree_related_product_id: id)
      end
    end
    redirect_to :back
  end

  def edit
  end

  def update
    @offer = Spree::Product.friendly.find(params[:offer_id])
  end

  def index
    @offer = Spree::Product.friendly.find(params[:offer_id])
    @related_offers = @offer.related_products.build
    all_related_offers = @offer.related_products
    @relates = destination_available(Spree::Product.active.where("spree_products.name != ?", @offer.name), all_related_offers)
    authorize @related_offers
  end

  def destroy
    @related_offer = Spree::RelatedProduct.find_by(product_id: params["related_offer"]["offer_id"], spree_related_product_id: params["related_offer"]["related_offer_id"])
    @related_offer.destroy
    render nothing: true
  end
end
