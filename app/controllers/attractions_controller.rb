require 'will_paginate/array'
class AttractionsController < ApplicationController
  layout false, :only => :wp_blog
  before_action :set_cache_control_headers, only: [:index, :show]
  before_action :set_attraction, only: [:show, :edit, :update, :destroy]

  def index
    @attractions = Attraction.select(:display_name, :description, :id, :place_id, :subscription_level, :status, :updated_at, :slug, :top_100, :parent_id).where.not(status: "removed")
    set_surrogate_key_header Attraction.table_key, @attractions.map(&:record_key)
    respond_to do |format|
      format.html
      format.json { render json: @attractions }  # respond with the created JSON object
    end
  end

  def show
    # @place = Place.find(@attraction.id)
    @optimum_times =  @attraction.subcategories.select {|cat| cat.category_type == "optimum_time"}
    @durations = @attraction.subcategories.select {|cat| cat.category_type == "duration"}
    @subcategories = @attraction.subcategories.select {|cat| cat.category_type == "subcategory"}
    @accessibilities = @attraction.subcategories.select {|cat| cat.category_type == "accessibility"}
    @prices = @attraction.subcategories.select {|cat| cat.category_type == "price"}

    @good_to_know = @attraction.good_to_knows.limit(6)

    @attraction_to_visit = @attraction.children.active

    @attraction_to_visit = @attraction_to_visit.sort do |x, y|
      y.videos.size <=> x.videos.size
    end

    @attraction_to_visit = @attraction_to_visit.paginate( page: params[:places_to_visit_page], per_page: 6 )

    if @attraction.parent.blank?
      if @attraction.primary_category.present? && @attraction.primary_category.id == 2
        @more_attractions = Attraction.includes(:country, :quality_average, :videos).where(primary_category_id: 1).where('attractions.id != ?', @attraction.id).where(country_id: @attraction.country_id)
      else
        @more_attractions = Attraction.includes(:country, :quality_average, :videos).where(primary_category: @attraction.primary_category).where('attractions.id != ?', @attraction.id).where(country_id: @attraction.country_id)
      end
    else
      if @attraction.primary_category.present? && @attraction.primary_category.id == 2
        @more_attractions = Attraction.includes(:country, :quality_average, :videos).where(primary_category_id: 1).where('places.id != ?', @place.id).where("status = ?", "live").where(parent_id: @place.parent_id)
      else
        @more_attractions = Attraction.includes(:country, :quality_average, :videos).where(primary_category: @attraction.primary_category).where('attractions.id != ?', @attraction.id).where("status = ?", "live").where(parent_id: @attraction.parent_id)
      end
    end

    @famous_faces = @attraction.country.famous_faces.active

    @more_attractions = @more_attractions.sort do |x, y|
      y.videos.size <=> x.videos.size
    end

    @more_attractions = @more_attractions.paginate(page: params[:more_places_page], per_page: 6 )

    @reviews = @attraction.reviews.active.paginate(page: params[:reviews_page], per_page: params[:reviews_page].nil?? 6 : 3 )
    @deals = @attraction.deals.active #.paginate(page: params[:deals_page], per_page: params[:deals_page].nil?? 6 : 3 )
    @review = Review.new

    @stories = @attraction.posts.active
    @stories += @attraction.stories.active
    @stories = @stories.sort{|x, y| x.publish_date <=> y.publish_date}.reverse.paginate(page: params[:stories_page], per_page: 4)

    active_user_photos = @attraction.user_photos.active
    @photos = (@attraction.photos.active + active_user_photos).sort {|x, y| x.created_at <=> y.created_at}.paginate(:page => params[:active_photos], per_page: 3)
    @photos_hero = @photos.first(6)
    @videos = @attraction.videos.active.paginate(:page => params[:active_videos], per_page:4)

    @related_places = @attraction.children
    @last_video = @attraction.videos.active.last
    @fun_facts = @attraction.fun_facts
    @set_body_class = "virgin-body" if @attraction.display_name == "Virgin Australia"
    @trip_advisor_data = @attraction.trip_advisor_info

    view = "attraction"
    @set_body_class = "thing-page dismiss-mega-menu-search"

    respond_to do |format|
      format.html { render view, :layout => !request.xhr? }
      format.json { render json: @attraction }
    end

  end

  def wp_blog
    @blog = ApiBlog.find_blog_id(params[:id].to_i, params[:attraction])
    @attraction = Attraction.find_by_slug(params[:attraction])
  end

  def new;end

  def edit
  end

  def create
    @attraction = Attraction.new(attraction_params)
    flash[:notice] = 'Attraction was successfully created.' if @attraction.save
    respond_with(@attraction)
  end

  def update
    flash[:notice] = 'Attraction was successfully updated.' if @attraction.update(attraction_params)
    respond_with(@attraction)
  end

  def destroy
    @attraction.destroy
    respond_with(@attraction)
  end

  def import_subcategories
    Attraction.import_subcategories(params[:file])
    redirect_to attractions_path, notice: "Attractions imported."
  end

  def import_update
    Attraction.import_update(params[:file])
    head 200, content_type: "text/html", notice: "Attraction updated."
  end

  private
    def set_attraction
      @attraction = Attraction.friendly.find(params[:id])
    end

    def attraction_params
      params[:attraction]
    end
end
