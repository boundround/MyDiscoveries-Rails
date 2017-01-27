class OffersController < ApplicationController
  # before_action :check_user_authorization, except: [:show, :paginate_on_idx]

  before_action :check_user_authorization, except: [:show, :paginate_reviews, :paginate_media, :paginate_on_idx, :clone, :paginate_offers]
  before_action :set_offer, only: [:show, :update, :edit, :destroy, :paginate_reviews, :paginate_media, :choose_hero, :update_hero, :clone]
  before_action :set_media, only: [:show, :paginate_media]

  def show
    #@map_marker = Attraction.first
    @photos = @offer.photos.active
    @videos = @offer.videos.active.order(:priority).paginate(:page => params[:active_videos], per_page:3)
    @last_video = @offer.videos.active.order(:priority).first
    @reviews = @offer.reviews.active.paginate(page: params[:reviews_page], per_page: 6)
    @review  = @offer.reviews.build
  end

  def new
    @offer = Offer.new(tags: [""])
  end

  def all_offers
    @featured_offers = Offer.all
  end

  def paginate_reviews
    @reviews = @offer.reviews.active.paginate(page: params[:reviews_page], per_page: 6)
    respond_to do |format|
      format.js { render 'shared/paginate_reviews' }
    end
  end

  def new_livn_offer
  end

  def create_livn_offer
    response = Offer::Livn::Create.call(params[:livn_product_id])

    if response.success?
      redirect_to offers_path, notice: "Offer '#{response.offer.name}' successfully created"
    else
      flash.now[:alert] = response.errors.join(', ')
      render :new_livn_offer
    end
  end

  def index
    @offers = Offer.all
    @featured_offers = Offer.featured_offers.paginate(per_page: 2, page: params[:featured_offers_page])
  end

  def cms_index
    @offers = Offer.all
  end

  def create
    @offer = Offer.new(offer_params)
    @offer.tags.select!(&:present?)
    if @offer.save
      redirect_to(edit_offer_path(@offer), notice: 'Offer succesfully saved')
    else
      flash.now[:alert] = 'Offer not saved!'
      render :new
    end
  end

  def update
    @offer.assign_attributes(offer_params)
    @offer.tags.select!(&:present?)
    if @offer.save
      if params[:offer][:inclusions]
        @offer.inclusion_list = params[:offer][:inclusions].join(', ')
        @offer.save
      end
      redirect_to edit_offer_path(@offer), notice: "Offer Updated"
    else
      flash.now[:alert] = 'Sorry, there was an error updating this Offer'
      render :edit
    end
  end

  def paginate_on_idx
    @offers = Offer.all.paginate(per_page: 3, page: params[:offer_page])
  end

  def clone
    @offer = Offer.find_by_slug(params[:id])
    @clone_offer = @offer.dup
    if @clone_offer.save
      redirect_to(edit_offer_path(@clone_offer), notice: 'Offer succesfully duplicated')
    else
      flash.now[:alert] = 'Offer not duplicated!'
      render :edit
    end
  end

  def paginate_offers
    @featured_offers = Offer.where(featured: true).paginate(per_page: 2, page: params[:featured_offers_page])
  end
  def paginate_media
  end

  def paginate_photos
    @offer = Offer.find_by_slug(params[:id])
    @photos = @offer.photos.paginate(:page => params[:active_photos], per_page: 3)
  end

  def paginate_videos
    @offer = Offer.find_by_slug(params[:id])
    @videos = @offer.videos.active.order(:priority).paginate(:page => params[:active_videos], per_page:3)
  end

  def destroy
    @offer.destroy
    redirect_to offers_path, notice: "Offer Deleted"
  end

  def edit

  end

  def choose_hero
    @offer_photos = @offer.photos.where.not(status: "removed")
    @photo = Photo.new
  end

  def update_hero
    photo_id = params[:photo_id]
    @offer.photos.each do |photo|
      if photo.id.to_s.eql? photo_id
         photo.hero = true
      else
        photo.hero = false
      end
        photo.save
    end
    @offer.save

    redirect_to choose_hero_offer_path(@offer)

  end

  private

  def set_offer
    @offer = Offer.friendly.find(params[:id])
  end

  def set_media
    photos = @offer.photos.active
    videos = @offer.videos.active
    media  = videos.count >= photos.count ? videos.zip(photos) : photos.zip(videos)
    @media = media.flatten.compact.paginate(page: params[:active_media], per_page: 4)
  end

  def offer_params
    params.require(:offer).permit(
      :id,
      :place_id,
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
      :validityStartDate,
      :validityEndDate,
      :publishStartDate,
      :publishEndDate,
      :supplier_product_code,
      :innovations_transaction_id,
      :operator_id,
      :show_in_mega_menu,
      :featured,
      :allow_installments,
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
      subcategory_ids: [],
      inclusion_list: []
    )
  end
end
