class SubcategoriesOffersController < ApplicationController
  def create
    @offer = Spree::Product.friendly.find(params[:offer_id])
    @offer.subcategories = []
    if params[:subcategories_offer]
      @subcategory_ids = params[:offers_subcategories][:subcategory_ids]
      @subcategory_ids.each do |id|
        @story.stories_subcategories.create(product_id: @offer.id, subcategory_id: id)
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
    @product = Spree::Product.friendly.find(params[:offer_id])
    @offer_subcategories = @product.subcategories.build
    @offer = @product
    @subcategories = Subcategory.all
  end

  def destroy
    @subcategories_offer = Spree::ProductsSubcategory.find_by(product_id: params["offers_subcategories"]["offer_id"], subcategory_id: params["offers_subcategories"]["subcategory_id"])
    @subcategories_offer.destroy
    render nothing: true
  end
end
