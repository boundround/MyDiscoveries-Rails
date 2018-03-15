class OffersController < ApplicationController
  before_action -> { check_user_authorization('Spree::Product') }, except: [
    :show,
    :paginate_reviews,
    :paginate_media,
    :paginate_on_idx,
    :paginate_offers
  ]
  before_action :set_offer, only: [
    :show,
    :update,
    :edit,
    :destroy,
    :paginate_reviews,
    :paginate_media,
    :update_hero,
    :load_options
  ]
  before_action :set_media, only: %i[show paginate_media]

  def show
    @photos = @offer.photos.active.uniq.order(:priority)
    @videos = @offer.videos.active.order(:priority)
    @galeries = @videos + @photos
    @reviews = @offer.reviews.active.paginate(page: params[:reviews_page], per_page: 6)
    @review  = @offer.reviews.build
    @operator = @offer.operator
    @book_guarantee = Configurable.book_guarantee

    check_product_options

    respond_to do |format|
      format.html
      format.pdf do
        render  pdf: @offer.name,
                dpi:  100,
                lowquality: true,
                disable_internal_links: true,
                disable_external_links: true,
                image_quality: 20,
                margin: { bottom: 30, top: 10 },
                footer: { html: { template: 'offers/footer.pdf.erb' } }
      end
    end
  end

  def new
    @offer = Spree::Product.new(tags: [''])
    @book_guarantee = Configurable.book_guarantee
  end

  def load_options
    check_product_options
    respond_to do |format|
      format.js
    end
  end

  def check_product_options
    
    @maturities = @offer.variants.map(&:maturity).compact.uniq unless @offer.disable_maturity?
    @bed_types = @offer.variants.map(&:bed_type).compact.uniq unless @offer.disable_bed_type?
    @room_types = @offer.variants.map(&:room_type).compact.uniq unless @offer.disable_room_type?
    @departure_cities = @offer.variants.map(&:departure_city).compact.uniq unless @offer.disable_departure_city?
    @package_options  = @offer.variants.map(&:package_option).compact.uniq unless @offer.disable_package_option?
    
    unless @offer.disable_departure_date?
      @departure_dates  = @offer.variants
                                .map { |v| v.departure_date.try(:to_date).try(:to_s) }
                                .uniq.sort { |x, y| x <=> y }

      @departure_dates = @departure_dates.map { |date| DateTime.parse(date).strftime('%d %B %Y') }.zip(@departure_dates)
      if @departure_dates.present? && Date.parse(@departure_dates.last[1]) > DateTime.new(2049)
        @departure_dates.last[0] = 'Undecided. Please call.'
      end

    end

    if !@offer.disable_accommodation?
      @accommodations   = @offer.variants.
        map{ |v| v.accommodation }.compact.uniq
    end
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
      redirect_to offers_path, notice: "Product '#{response.offer.name}' successfully created"
    else
      flash.now[:alert] = response.errors.join(', ')
      render :new_livn_offer
    end
  end

  def index
    @featured_offers = Spree::Product.featured_products.active.where('publishenddate >= ?', Date.today).paginate(per_page: 2, page: params[:featured_offers_page])
  end

  def cms_index
    @offers = Spree::Product.where("status != ?", "removed")
  end

  def create
    @offer = Spree::Product.new(product_params)
    @offer.tags.select!(&:present?)
    @offer.departure_dates = params[:product][:departure_dates][:dates] unless params[:product][:departure_dates].blank?
    if @offer.save
      redirect_to(edit_offer_path(@offer), notice: 'Product succesfully saved')
    else
      flash.now[:alert] = 'Product not saved!'
      render :new
    end
  end

  def update
    @offer.assign_attributes(product_params)
    @offer.tags.select!(&:present?)
    @offer.places_visited.select!(&:present?)
    @offer.inclusion_list = params[:product][:inclusions] if params[:product][:inclusions].present?
    @offer.departure_dates = params[:product][:departure_dates][:dates] unless params[:product][:departure_dates].blank?

    respond_to do |format|
      format.html do
        if @offer.save
          redirect_to edit_offer_path(@offer), notice: "Product Updated"
        else
          flash.now[:alert] = @offer.errors.full_messages.to_sentence
          render :edit
        end
      end
      format.js
    end
  end

  def paginate_on_idx
    @offers = Spree::Product.active.paginate(per_page: 4, page: params[:product_page])
  end

  def paginate_offers
    @featured_offers = Spree::Product.featured_products.paginate(per_page: 2, page: params[:featured_offers_page])
  end

  def paginate_media
  end

  def destroy
    @offer.destroy
    redirect_to cms_index_offers_path, notice: "Offer Deleted"
  end

  def edit
    @book_guarantee = Configurable.book_guarantee
  end

  def update_hero
    photo_id = params[:photo_id]

    old_hero = @offer.photos.where(hero: true)
    unless old_hero.blank?
      old_hero.each do |old_h|
        old_h.update!(hero: false)
      end
    end

    new_hero = Photo.find(photo_id.to_i)
    new_hero.update!(hero: true)
    @offer.save

    redirect_to choose_hero_offer_photos_path(@offer)
  end

  private

  def set_offer
    @offer = Spree::Product.friendly.find(params[:id])
  end

  def set_media
    photos = @offer.photos.active.uniq
    videos = @offer.videos.active
    media  = videos.count >= photos.count ? videos.zip(photos) : photos.zip(videos)
    @media = media.flatten.compact.paginate(page: params[:active_media], per_page: 4)
  end

  def product_params
    params.require(:product).permit(
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
      :publishstartdate,
      :publishenddate,
      :supplier_product_code,
      :innovations_transaction_id,
      :operator_id,
      :show_in_mega_menu,
      :featured,
      :allow_installments,
      :item_id,
      :child_item_id,
      :number_of_days,
      :number_of_nights,
      :test_product,
      :itinerary,
      :room_type,
      :other,
      :disable_bed_type,
      :disable_maturity,
      :disable_room_type,
      :disable_package_option,
      :disable_accommodation,
      :disable_departure_date,
      :disable_departure_city,
      :room_type_label,
      :package_option_label,
      :per_adult_overwrite,
      :voucher_booking_essentials,
      :marketing_headline,
      :product_type,
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
      inclusion_list: [],
      places_visited: [],
      sticker_ids: []
    )
  end
end
