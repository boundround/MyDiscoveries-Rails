require 'will_paginate/array'
require 'iso-639'

class PlacesController < ApplicationController
  layout false, :only => :wp_blog
  before_action :set_cache_control_headers, only: [:index, :show]
  before_action :find_place_by_slug, only: [:show]
  before_action :check_user_authorization, only: [:index, :create, :new, :update, :edit, :destroy]

  def new
    @place = Place.new(tags: [""])
    @places = Place.active.where(is_area: true).order(display_name: :asc)
    @countries = Country.all
    @regions = Region.all
    @subcategories = Subcategory.order(name: :asc)
    @primary_categories = PrimaryCategory.all
  end

  def create
    @place = Place.new(place_params)

    if @place.save
      redirect_to edit_place_path(@place), notice: 'Place succesfully saved'
    else
      @places = Place.active.where(is_area: true).order(display_name: :asc)
      @countries = Country.all
      @regions = Region.all
      render action: :new, notice: 'Place not saved!'
    end
  end

  def wp_feed
    @places = Place.wp_api_feed
  end

  def stamp_confirmation
    @place = Place.find_by_slug params[:id]
    @photo = @place.photos.where(hero: true).first
  end

  def places_with_subcategories
    @places = Place.active.includes(:subcategories)
    @subcategories = Subcategory.all.order(category_type: :asc)
  end

  def areas_with_subcategories
    @places = Place.active.includes(:subcategories).where(is_area: true)
    @subcategories = Subcategory.all.order(category_type: :asc)
  end

  def edit_parents
    @places = Place.active.order(display_name: :asc)
  end

  def edit
    @set_body_class = "br-body"
    @place = Place.friendly.find(params[:id])
    @places = Place.active.where(is_area: true).order(display_name: :asc)
    @countries = Country.all
    @regions = Region.all
    @subcategories = Subcategory.order(name: :asc)
    @primary_categories = PrimaryCategory.all
    @three_d_video = ThreeDVideo.new
  end

  def update
    @place = Place.friendly.find(params[:id])
    @place.assign_attributes(place_params)
    @place.tags.select!(&:present?)
    if @place.save
      respond_to do |format|
        format.json { render json: @place }
        format.html do
          redirect_to edit_place_path(@place), notice: 'Place succesfully updated'
        end
      end
    else
      redirect_to :back
    end
  end

  def seo_analysis
    @place = @search_optimizable = Place.friendly.find(params[:id])
  end

  def refresh_blog
    @place = Place.find_by_slug(params[:id])
    Rails.cache.delete(@place.slug)
    redirect_to :back, notice: "Blog posts for #{@place.display_name} have been refreshed"
  end

  def new_edit
    @set_body_class = "br-body"
    @place = Place.friendly.find(params[:id])
    @places = Place.active.order(display_name: :asc)
    @countries = Country.all
    @regions = Region.all
    @subcategories = Subcategory.all
    @primary_categories = PrimaryCategory.all
    @three_d_video = ThreeDVideo.new
  end

  def destroy;end

  def content_rejected
    place_id = params["place-id"].to_i
    asset_type = params["asset-type"]
    asset_id = params["asset-id"]
    email = params["email"]
    comments = params["comments"]
    ContentRejected.send_rejected(place_id, asset_type, asset_id, email, comments)
    redirect_to :back, notice: 'Thank you. Comments sent'
  end

  def geoquery
    @place_areas = Place.active.pluck(:display_name, :id, :place_id, :subscription_level, :status, :updated_at)

    respond_to do |format|
      format.json { render json: @place_areas }  # respond with the created JSON object
    end
  end

  def merge
  end

  def index
    @places = Place.select(:display_name, :description, :id, :place_id, :subscription_level, :status, :updated_at, :is_area, :slug, :top_100, :parent_id, :focus_keyword, :seo_title, :meta_description).where.not(status: "removed").where(is_area: true)
    set_surrogate_key_header Place.table_key, @places.map(&:record_key)
    respond_to do |format|
      format.html
      format.json { render json: @places }  # respond with the created JSON object
    end
  end

  def all_edited

    @all_edited = Place.joins(:photos).where("photos.status = 'edited'")
    @all_edited += Place.joins(:videos).where("videos.status = 'edited'")
    @all_edited += Place.joins(:fun_facts).where("fun_facts.status = 'edited'")
    @all_edited += Place.joins(:discounts).where("discounts.status = 'edited'")

    @all_edited = @all_edited.uniq

    @all_content = []

    @all_edited.each do |place|
      place.photos.edited.each do |photo|
        @all_content.push photo
      end
      place.videos.edited.each do |video|
        @all_content.push video
      end
      place.fun_facts.edited.each do |fun_fact|
        @all_content.push fun_fact
      end
      place.discounts.edited.each do |discount|
        @all_content.push discount
      end
    end

  end

  def search
    @places = Place.where.not(subscription_level: ['out', 'draft'])
              .text_search(params[:term])
    @places = ActiveSupport::JSON.decode(@places.to_json)

    respond_to do |format|
      format.json { render json: @places.to_json}  # respond with the created JSON object
    end
  end

  def show
    @places_to_visit = @place.places_to_visits.paginate( page: params[:places_to_visit_page], per_page: 6 )
    @deals = @place.deals.active
    @offers = @place.products.active.paginate(page: params[:offers_page], per_page: 4)
    @stories = @place.place_stories.reverse.paginate(page: params[:stories_page], per_page: 4)
    @map_marker = @place.markers
    @review = @place.reviews.build
    @videos = @place.videos.active.order(:priority)
    @photos = @place.active_user_photos
    @galeries = @videos + @photos
    @photos_hero = @photos.first(6)
    @fun_facts = @place.fun_facts
    @country_currency, @languages = @place.country_extra_data
    @tab_infos = @place.tab_infos.reorder(:created_at)
    
    respond_to do |format|
      format.html #{ render view, :layout => !request.xhr? }
      format.json { render json: @place }
    end
  end

  def paginate_offers
    @place = Place.find_by_slug(params[:id])
    @offers = @place.products.paginate(page: params[:offers_page], per_page: 4)
  end

  def paginate_deals
    @place = Place.find_by_slug(params[:id])
    @deals = @place.deals.active.paginate(:page => params[:active_photos], per_page: 4)
  end

  def paginate_place_to_visit
    @place = Place.find_by_slug(params[:id])
    @places_to_visit = @place.places_to_visits.paginate( page: params[:places_to_visit_page], per_page: 6 )
  end

  def paginate_reviews
    @place = Place.find_by_slug(params[:id])
    @reviews = @place.reviews.active.paginate(page: params[:reviews_page], per_page: params[:reviews_page].nil?? 6 : 3 )
    respond_to do |format|
      format.js { render 'shared/paginate_reviews' }
    end
  end

  def paginate_stories
    @place = Place.find_by_slug(params[:id])
    @stories = @place.place_stories.reverse.paginate(page: params[:stories_page], per_page: 4)
  end

  def transfer_assets
    if user_signed_in? && current_user.admin?
      @from_place = Place.find(params[:place][:from_place_id])
      @to_place = Place.find(params[:place][:to_place_id])

      if params[:remove] == true
        @from_place.status = "removed"
      end

      @from_place.photos.each do |photo|
        photo.place_id = @to_place.id
        unless photo.save
          raise "Photo #{photo.id} not transferred"
        end
      end

      @from_place.videos.each do |photo|
        video.place_id = @to_place.id
        unless video.save
          raise "Video #{video.id} not transferred"
        end
      end

      @from_place.reviews.each do |review|
        review.reviewable = @to_place
        unless review.save
          raise "Review not transferred"
        end
      end

      @from_place.stories.each do |story|
        story.reviewable = @to_place
        unless story.save
          raise "Story #{story.id} not transferred"
        end
      end

      @from_place.user_photos.each do |photo|
        photo.place_id = @to_place.id
        unless photo.save
          raise "Photo #{photo.id} not transferred"
        end
      end
    end
  end

  def user_created
    @places = Place.where(user_created: true).reorder(:created_at)
  end

  def publishing_queue
  end

  def import
    Place.import(params[:file])
    redirect_to places_path, notice: "Places imported."
  end

  def import_update
    Place.import_update(params[:file])
    head 200, content_type: "text/html", notice: "Places updated."
  end

  def import_subcategories
    Place.import_subcategories(params[:file])
    redirect_to places_path, notice: "Places imported."
  end

  def send_postcard
    name = params[:name]
    email = params[:customer]
    message = params[:message]
    photo = params[:photo]
    place = params[:place]
    area = params[:area]
    country = params[:country]
    Share.postcard(name, email, message, photo, place, area, country).deliver
    redirect_to :back, notice: 'Postcard sent'
  end

  def mapdata
    @places_geojson = Place.all_geojson

    respond_to do |format|
      format.html
      format.json { render json: @places_geojson }  # respond with the created JSON object
    end
  end

  def liked_places
    @places = {}
    @liked_places = Place.where.not(slug: params[:placeIds])

    @liked_places.each do |place|
      @places[place.slug] = like_icon(place)
    end

    respond_to do |format|
      format.json { render json: @places}
    end
  end

  def tags
    params[:sort] ||= "id"
    params[:direction] ||= "asc"
    @places = Place.order(params[:sort] + " " + params[:direction]).paginate(:per_page => 30, :page => params[:page])
  end

  private
    def place_params
      if @place.present? && params[:place][:parent_attributes].present?
        unless @place.parent.blank?
          if (@place.parent.parentable_type == params[:place][:parent_attributes][:parentable_type])&&(@place.parent.parentable_id == params[:place][:parent_attributes][:parentable_id].to_i)
            params[:place].delete :parent_attributes

          elsif (@place.parent.parentable_type == params[:place][:parent_attributes][:parentable_type])||(@place.parent.parentable_id == params[:place][:parent_attributes][:parentable_id].to_i)
            @place.parent.delete()

          elsif params[:place][:parent_attributes][:parentable_type] == nil
            @place.parent.delete()
            params[:place].delete :parent_attributes
          else
            @place.parent.delete()
          end
        end
      end

      params.require(:place).permit(
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
        :short_description,
        :primary_category_id,
        :passport_icon,
        :address,
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
        :is_country,
        :zoom_level,
        :primary_area,
        :special_requirements,
        :top_100,
        :viator_link,
        :trip_advisor_url,
        :description_heading,
        :focus_keyword,
        :seo_title,
        :meta_description,
        :show_in_mega_menu,
        parent_attributes: [:parentable_id, :parentable_type],
        photos_attributes: [:id, :place_id, :photoable_id, :photoable_type, :hero, :title, :path, :caption, :alt_tag, :credit, :caption_source, :priority, :status, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
        videos_attributes: [:id, :youtube_id, :transcript, :hero, :priority, :title, :description, :place_id, :videoable_id, :videoable_type, :status, :country_include, :customer_approved, :customer_review, :approved_at, :_destroy],
        fun_facts_attributes: [:id, :content, :reference, :priority, :place_id, :status, :hero_photo, :photo_credit, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
        discounts_attributes: [:id, :description, :place_id, :status, :customer_approved, :customer_review, :approved_at, :country_include, :_destroy],
        user_photos_attributes: [:id, :title, :path, :caption, :hero, :story_id, :priority, :user_id, :place_id, :status, :google_place_id, :google_place_name, :instagram_id, :remote_path_url, :_destroy],
        three_d_videos_attributes: [:link, :caption, :place_id, :three_d_videoable_id, :three_d_videoable_type],
        tags: [],
        category_ids: [],
        subcategory_ids: [],
        similar_place_ids: [])
    end

    def find_place_by_slug
      @place = Place.includes(:quality_average, :subcategories, :similar_places => :similar_place).friendly.find(params[:id])

      if @place.is_area
        if request.path != place_path(@place)
          return redirect_to @place, :status => :moved_permanently
        end
      else
        @attraction = Attraction.includes(:quality_average, :subcategories, :similar_attractions => :similar_attraction).friendly.find(params[:id])
        return redirect_to @attraction, :status => :moved_permanently
      end
    end
end
