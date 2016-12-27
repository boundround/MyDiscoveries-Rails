class OffersController < ApplicationController
  before_action :check_user_authorization, except: :show
  before_action :set_offer, only: [ :show, :update, :edit, :destroy ]

  def show
    @map_marker = Attraction.first
    @photos = @offer.photos.last(3)
  end

  def new
    @offer = Offer.new(tags: [""])
  end

  def all_offers
    @featured_offers = Offer.all
  end

  def new_livn_offer
  end

  def create_livn_offer
    response = LivnOffersCreationService.call(params[:livn_product_id])

    if response.success?
      redirect_to offers_path, notice: "Offer '#{response.offer.name}' successfully created"
    else
      flash.now[:alert] = response.errors.join(', ')
      render :new_livn_offer
    end
  end

  def index
    @offers = Offer.all
    @featured_offers = Offer.all
  end

  def create
    @offer = Offer.new(offer_params)
    @offer.tags.select!(&:present?)
    if @offer.save
      redirect_to(offers_path, notice: 'Offer succesfully saved')
    else
      flash.now[:alert] = 'Offer not saved!'
      render :new
    end
  end

  def update
    @offer.assign_attributes(offer_params)
    @offer.tags.select!(&:present?)
    if @offer.save
      redirect_to offers_path, notice: "Offer Updated"
    else
      flash.now[:alert] = 'Sorry, there was an error updating this Offer'
      render :edit
    end
  end

  def destroy
    @offer.destroy
    redirect_to offers_path, notice: "Offer Deleted"
  end

  def edit

  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(
      :id,
      :attraction_id,
      :status,
      :name,
      :description,
      :minRateAdult,
      :minRateChild,
      :minRateInfant,
      :maxRateAdult,
      :maxRateChild,
      :maxRateInfant,
      :duration,
      :specialNotes,
      :operatingDays,
      :operatingDaysStr,
      :operatingSchedule,
      :locationStart,
      :latitudeStart,
      :longitudeStart,
      :distanceStartToRef,
      :locationEnd,
      :latitudeEnd,
      :longitudeEnd,
      :minAge,
      :maxAge,
      :requiredMultiple,
      :minUnits,
      :maxUnits,
      :pickupNotes,
      :dropoffNotes,
      :highlightsStr,
      :itineraryStr,
      :includes,
      :sellVouchers,
      :onlyVouchers,
      :voucherInstructions,
      :voucherValidity,
      :customStr1,
      :customStr2,
      :customStr3,
      :customStr4,
      :pickupRequired,
      :livn_product_id,
      :startDate,
      :endDate,
      { tags: [] },
      photos_attributes: [
        :id, :title, :path, :caption, :alt_tag, :credit, :caption_source,
        :priority, :status, :country_hero, :country_include, :_destroy, :hero
      ],
      videos_attributes: [
        :id, :vimeo_id, :title, :description, :priority, :status,
        :country_include, :_destroy
      ],
      attraction_ids: [],
      place_ids: [],
      country_ids: [],
      region_ids: [],
      subcategory_ids: []
    )
  end
end
