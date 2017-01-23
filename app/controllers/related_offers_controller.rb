class RelatedOffersController < ApplicationController

  def create
    @offer = Offer.friendly.find(params[:offer_id])
    @offer.related_offers = []
    if params[:related_offer]
      @related_place_ids = params[:related_offer][:related_offer_ids]
      @related_place_ids.each do |id|
        @offer.related_offers.create(offer_id: @offer.id, related_offer_id: id)
      end
    end

    redirect_to :back

  end

  def edit
  end

  def update
     @offer = Offer.friendly.find(params[:offer_id])
  end

  def index
    @offer = Offer.friendly.find(params[:offer_id])
    @related_offers = @offer.related_offers.build
    @relates = Offer.where(status: "live").order(name: :asc).where("offers.name != ?", @offer.name)
  end

  def destroy
    @related_offer = RelatedOffer.find_by(offer_id: params["related_offer"]["offer_id"], related_offer_id: params["related_offer"]["related_offer_id"])
    @related_offer.destroy
    render nothing: true
  end

  private
    def related_offers_params
      params.require(:related_offer).permit(:offer_id, :related_offer_ids => [])
    end

end
