class CountriesOffersController < ApplicationController

  def create
    @offer = Spree::Product.friendly.find(params[:offer_id])
    @offer.countries = []
    if params[:countries_offer]
      @countries_ids = params[:countries_offer][:country_ids]
      @countries_ids.each do |id|
        @offer.products_countries.create(product_id: @offer.id, country_id: id)
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
    @countries_offers = @offer.countries.build
    @countries = Country.order(display_name: :asc)
  end

  def destroy
    @offers_countries = Spree::ProductsCountry.find_by(
      product_id: params["countries_offer"]["product_id"],
      place_id: params["countries_offer"]["country_id"]
    )
    @offers_countries.destroy
    render nothing: true
  end
end
