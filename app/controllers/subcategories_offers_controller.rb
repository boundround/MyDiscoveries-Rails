class SubcategoriesOffersController < ApplicationController
  def create
    @offer = Offer.friendly.find(params[:offer_id])
    @offer.subcategories = []
    if params[:subcategories_offer]
      @subcategory_ids = params[:offers_subcategories][:subcategory_ids]
      @subcategory_ids.each do |id|
        @story.stories_subcategories.create(offer_id: @offer.id, subcategory_id: id)
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
    @offer_subcategories = @offer.subcategories.build
    @subcategories = Subcategory.all
  end

  def destroy
    @subcategories_offer = OffersSubcategory.find_by(offer_id: params["offers_subcategories"]["offer_id"], subcategory_id: params["offers_subcategories"]["subcategory_id"])
    @subcategories_offer.destroy
    render nothing: true
  end

  private
    def subcategories_stories_params
      params.require(:stories_subcategories).permit(:story_id, :subcategory_ids => [])
    end
end
