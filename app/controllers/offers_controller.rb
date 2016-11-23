class OffersController < ApplicationController
  before_action :check_user_authorization, except: :show

  def show
  end

  def new
    @offer = Offer.new(tags: [""])
  end

  def index
    @offers = Offer.all
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
    @offer = Offer.find(params[:id])
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
    @offer = Offer.find(params[:id])
    @offer.destroy
    redirect_to offers_path, notice: "Offer Deleted"
  end

  def edit
    @offer = Offer.find(params[:id])
  end

  private

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
      { tags: [] }
    )
  end
end
