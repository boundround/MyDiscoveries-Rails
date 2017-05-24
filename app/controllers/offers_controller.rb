class OffersController < ApplicationController
  before_action -> { check_user_authorization('Spree::Product') }, except: [
    :show, :paginate_reviews, :paginate_media, :paginate_on_idx, :clone, :paginate_offers
  ]
  before_action :set_offer, only: [
    :show, :update, :edit, :destroy, :paginate_reviews, :paginate_media, :update_hero, :clone
  ]
  before_action :set_media, only: [:show, :paginate_media]

  def show
    #@map_marker = Attraction.first
    @photos = @offer.photos.active
    @videos = @offer.videos.active.order(:priority)
    @galeries = @videos + @photos
    @reviews = @offer.reviews.active.paginate(page: params[:reviews_page], per_page: 6)
    @review  = @offer.reviews.build
    @operator = @offer.operator
    @book_guarantee = Configurable.book_guarantee

    @maturities       = @offer.variants.map{ |v| v.maturity.titleize }.uniq
    @bed_types        = @offer.variants.map{ |v| v.bed_type.titleize }.uniq
    @departure_cities = @offer.variants.map{ |v| v.departure_city }.uniq
    respond_to do |format|
      format.html
      format.pdf do
      render pdf: @offer.name,
        dpi:  100,
        lowquality: true,
        disable_internal_links: true,
        disable_external_links: true,
        image_quality: 20,
        margin: {bottom:30,top: 10},
        footer: { html: { template: 'offers/footer.pdf.erb' }}
      end
    end
  end

  def new
    @offer = Spree::Product.new(tags: [""])
    @book_guarantee = Configurable.book_guarantee
  end

  def all_offers
    @featured_offers = Spree::Product.all
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
    @offers = Spree::Product.active
    @featured_offers = Spree::Product.featured_products.active.paginate(per_page: 2, page: params[:featured_offers_page])
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
    if @offer.save
      redirect_to edit_offer_path(@offer), notice: "Product Updated"
    else
      flash.now[:alert] = 'Sorry, there was an error updating this Product'
      render :edit
    end
  end

  def paginate_on_idx
    @offers = Spree::Product.active.paginate(per_page: 4, page: params[:product_page])
  end

  def clone
    @offer = Spree::Product.find_by_slug(params[:id])
    @clone_offer = @offer.deep_clone(
      include: [
        :photos,
        :videos,
        :regions,
        :places,
        :related_products,
        :subcategories,
        :variants,
        :master
      ]
    )
    if @clone_offer.save
      redirect_to(edit_offer_path(@clone_offer), notice: 'Product succesfully duplicated')
    else
      flash.now[:alert] = 'Product not duplicated!'
      render :edit
    end
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
    @offer.photos.each do |photo|
      if photo.id.to_s.eql? photo_id
         photo.hero = true
      else
        photo.hero = false
      end
        photo.save
    end
    @offer.save

    redirect_to choose_hero_offer_photos_path(@offer)

  end

  private

  def set_offer
    @offer = Spree::Product.friendly.find(params[:id])
  end

  def set_media
    photos = @offer.photos.active
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
      places_visited: []
    )
  end
end
