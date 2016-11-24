require 'will_paginate/array'
class AttractionsController < ApplicationController
  before_action :set_cache_control_headers, only: [:index, :show]
  before_action :set_attraction, only: [:show]
  before_action :check_user_authorization, only: [:index, :create, :new, :update, :edit, :destroy]

  def index
    @attractions = Attraction.select(:display_name, :description, :id, :place_id, :subscription_level, :status, :updated_at, :slug, :top_100, :parent_id, :focus_keyword, :seo_title, :meta_description).where.not(status: "removed")
    set_surrogate_key_header Attraction.table_key, @attractions.map(&:record_key)
    respond_to do |format|
      format.html
      format.json { render json: @attractions }  # respond with the created JSON object
    end
  end

  def show
    subcategories    = @attraction.all_subcategories
    @optimum_times   = (subcategories.blank? || subcategories['duration'].blank?) ? [] : subcategories['duration']
    @durations       = (subcategories.blank? || subcategories['optimum_time'].blank?) ? [] : subcategories['optimum_time']
    @accessibilities = (subcategories.blank? || subcategories['accessibility'].blank?) ? [] : subcategories['accessibility']
    @prices          = (subcategories.blank? || subcategories['price'].blank?) ? [] : subcategories['price']

    @good_to_know = @attraction.good_to_knows.limit(6)
    @more_attractions = @attraction.siblings.paginate(page: params[:more_attractions_page], per_page: 6 )
    @reviews = @attraction.reviews.active.paginate(page: params[:reviews_page], per_page: 6)
    @deals = @attraction.deals.active
    @review = Review.new
    @stories = @attraction.attraction_stories.paginate(page: params[:stories_page], per_page: 4)
    @photos = @attraction.active_user_photos.paginate(:page => params[:active_photos], per_page: 3)
    @videos = @attraction.videos.active.paginate(:page => params[:active_videos], per_page: 3)
    @trip_advisor_data = @attraction.trip_advisor_info
    @set_body_class = (@attraction.display_name == "Virgin Australia") ? "virgin-body" : "thing-page dismiss-mega-menu-search"

    respond_to do |format|
      format.html
      format.json { render json: @attraction }
    end
  end

  def seo_analysis
    @attraction = @search_optimizable = Attraction.friendly.find(params[:id])
  end

  def paginate_more_attractions
    @attraction = Attraction.friendly.find(params[:id])
    @more_attractions = @attraction.siblings.paginate(page: params[:more_attractions_page], per_page: 6 )
  end

  def paginate_videos
    @attraction = Attraction.find_by_slug(params[:id])
    @videos = @attraction.videos.active.paginate(:page => params[:active_videos], per_page: 3)
  end

  def paginate_photos
    @attraction = Attraction.find_by_slug(params[:id])
    @photos = @attraction.active_user_photos.paginate(:page => params[:active_photos], per_page: 3)
  end

  def paginate_deals
    @attraction = Attraction.find_by_slug(params[:id])
    @deals = @attraction.deals.active.paginate(:page => params[:active_photos], per_page: 3)
  end

  def paginate_reviews
    @attraction = Attraction.find_by_slug(params[:id])
    @reviews = @attraction.reviews.active.paginate(page: params[:reviews_page], per_page: 6)
  end

  def paginate_stories
    @attraction = Attraction.find_by_slug(params[:id])
    @stories = @attraction.attraction_stories.paginate(page: params[:stories_page], per_page: 4)
  end

  def new
    @attraction = Attraction.new
    @places = Place.active.where(is_area: true).order(display_name: :asc)
    @attractions = Attraction.active.order(display_name: :asc)
    @countries = Country.all
    @regions = Region.all
    @subcategories = Subcategory.order(name: :asc)
    @primary_categories = PrimaryCategory.all
  end

  def edit
    @set_body_class = "br-body"
    @attraction = Attraction.friendly.find(params[:id])
    @places = Place.active.where(is_area: true).order(display_name: :asc)
    @attractions = Attraction.active.order(display_name: :asc)
    @countries = Country.all
    @regions = Region.all
    @subcategories = Subcategory.order(name: :asc)
    @primary_categories = PrimaryCategory.all
    @three_d_video = ThreeDVideo.new
  end

  def create
    @attraction = Attraction.new(attraction_params)

    if @attraction.save
      redirect_to edit_attraction_path(@attraction), notice: 'Attraction succesfully saved'
    else
      render action: :new, notice: 'Attraction not saved!'
    end
  end

  def update
    @attraction = Attraction.friendly.find(params[:id])

    if @attraction.update(attraction_params)
      respond_to do |format|
        format.json { render json: @attraction }
        format.html do
          @attraction.photos.each do |photo|
            photo.add_or_remove_from_country(@attraction.country)
          end

          @attraction.videos.each do |video|
            video.add_or_remove_from_country(@attraction.country)
          end

          @attraction.fun_facts.each do |fun_fact|
            fun_fact.add_or_remove_from_country(@attraction.country)
          end
          redirect_to edit_attraction_path(@attraction), notice: 'Attraction succesfully updated'
        end
      end
    else
      redirect_to :back
    end
  end

  def destroy;end

  def import
    Attraction.import(params[:file])
    redirect_to attractions_path, notice: "Attractions imported."
  end

  def import_update
    Attraction.import_update(params[:file])
    head 200, content_type: "text/html", notice: "Attraction updated."
  end

  def import_subcategories
    Attraction.import_subcategories(params[:file])
    redirect_to attractions_path, notice: "Attractions imported."
  end

  def update_hero
    @attraction = Attraction.friendly.find(params[:id])
    photo_id = params[:photo_id]
    if params[:type].eql? "UserPhoto"
      @attraction.user_photos.each do |photo|
        if photo.id.to_s.eql? photo_id
           photo.hero = true
        else
          photo.hero = false
        end
          photo.save
      end
      @attraction.photos.each do |photo|
        photo.hero = false
        photo.save
      end
      redirect_to choose_hero_attraction_path(@attraction)
    else
      @attraction.photos.each do |photo|
        if photo.id.to_s.eql? photo_id
           photo.hero = true
        else
          photo.hero = false
        end
          photo.save
      end
      @attraction.user_photos.each do |photo|
        photo.hero = false
        photo.save
      end
      @attraction.save # needed to update search index
      redirect_to choose_hero_attraction_path(@attraction)
    end
  end

  def choose_hero
    @attraction = Attraction.find_by_slug(params[:id])
    @user_photos = @attraction.user_photos
    @attraction_photos = @attraction.photos
    @photo = Photo.new
  end

  private
    def set_attraction
      @attraction = Attraction.includes(:quality_average, :subcategories, :similar_attractions => :similar_attraction).friendly.find(params[:id])
      if request.path != attraction_path(@attraction)
        return redirect_to @attraction, :status => :moved_permanently
      end
    end

    def attraction_params
      params.require(:attraction).permit(
        :code,
        :identifier,
        :display_name,
        :description,
        :show_on_school_safari,
        :school_safari_description,
        :booking_url,
        :display_address,
        :subscription_level,
        :latitude,
        :longitude,
        :logo,
        :phone_number,
        :website,
        :booking_url,
        :icon,
        :map_icon,
        :published_at,
        :unpublished_at,
        :minimum_age,
        :maximum_age,
        :street_number,
        :route,
        :sublocality,
        :locality,
        :state,
        :post_code,
        :created_by,
        :user_created,
        :hero_image,
        :remote_hero_image_url,
        :crop_x,
        :crop_y,
        :crop_h,
        :crop_w,
        :customer_approved,
        :customer_review,
        :approved_at,
        :country_id,
        :bound_round_place_id,
        :meta_description,
        :primary_category_id,
        :passport_icon,
        :address,
        :area_id,
        :parent_id,
        :parentable_id,
        :parentable_type,
        :email,
        :tag_list,
        :location_list,
        :activity_list,
        :place_id,
        :status,
        :footer_include,
        :is_area,
        :primary_area,
        :special_requirements,
        :top_100,
        :viator_link,
        :trip_advisor_url,
        parent_attributes: [:parentable_id, :parentable_type],
        photos_attributes: [:id, :place_id, :photoable_id, :photoable_type, :attraction_id, :hero, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :status, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
        videos_attributes: [:id, :vimeo_id, :youtube_id, :transcript, :hero, :priority, :title, :description, :place_id, :videoable_id, :videoable_type, :attraction_id, :area_id, :status, :country_include, :customer_approved, :customer_review, :approved_at, :_destroy],
        fun_facts_attributes: [:id, :content, :reference, :priority, :area_id, :place_id, :attraction_id, :status, :hero_photo, :photo_credit, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
        discounts_attributes: [:id, :description, :place_id, :attraction_id, :area_id, :status, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
        user_photos_attributes: [:id, :title, :path, :caption, :hero, :story_id, :priority, :user_id, :place_id, :attraction_id, :area_id, :status, :google_place_id, :google_place_name, :instagram_id, :remote_path_url, :_destroy],
        three_d_videos_attributes: [:link, :caption, :place_id, :attraction_id, :three_d_videoable_id, :three_d_videoable_type],
        category_ids: [],
        subcategory_ids: [],
        similar_place_ids: [])
    end
end
