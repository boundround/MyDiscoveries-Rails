require 'will_paginate/array'

class PhotosController < ApplicationController

  def index
    @featured_photos = Photo.limit(3) #task uncompleted

    @photos = (Photo.all.order("created_at DESC") + UserPhoto.all.order("created_at DESC") ).sort{|x,y|x.created_at <=> y.created_at}.paginate(page: params[:page], per_page: 6) #check #add paginate
    # @popular #task uncompleted

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @photos }
    end
  end

  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @photo }
    end
  end

  def place_update
    @photo = Photo.find(params[:id])
      if @photo.update(photo_params)
        redirect_to choose_hero_place_photos_path(@photo.photoable), notice: "Photo Succesfully Updated"
      else
        redirect_to choose_hero_place_photos_path(@photo.photoable), notice: "Error"
      end
  end

  def attraction_update
    @photo = Photo.find(params[:id])
      if @photo.update(photo_params)
        redirect_to choose_hero_attraction_photos_path(@photo.photoable), notice: "Attraction Succesfully Updated"
      else
        redirect_to choose_hero_attraction_photos_path(@photo.photoable), notice: "Error"
      end
  end

  def region_update
    @photo = Photo.find(params[:id])
      if @photo.update(photo_params)
        redirect_to choose_hero_region_photos_path(@photo.photoable), notice: "Region Succesfully Updated"
      else
        redirect_to choose_hero_region_photos_path(@photo.photoable), notice: "Error"
      end
  end

  def country_update
    @photo = Photo.find(params[:id])
      if @photo.update(photo_params)
        redirect_to choose_hero_country_photos_path(@photo.photoable), notice: "Country Succesfully Updated"
      else
        redirect_to choose_hero_country_photos_path(@photo.photoable), notice: "Error"
      end
  end

  def offer_update
    @photo = Photo.find(params[:id])
      if @photo.update(photo_params)
        redirect_to choose_hero_offer_photos_path(@photo.photoable), notice: "Offer Succesfully Updated"
      else
        redirect_to choose_hero_offer_photos_path(@photo.photoable), notice: "Error"
      end
  end

  def story_update
    @photo = Photo.find(params[:id])
      if @photo.update(photo_params)
        redirect_to choose_hero_story_photos_path(@photo.photoable), notice: "Story Succesfully Updated"
      else
        redirect_to choose_hero_story_photos_path(@photo.photoable), notice: "Error"
      end
  end

  def all_photos
    if params[:place_id]
      @place = Place.friendly.find(params[:place_id])
    elsif params[:attraction_id]
      @attraction = Attraction.friendly.find(params[:attraction_id])
    elsif params[:country_id]
      @country = Country.friendly.find(params[:country_id])
    end

    @photos = @place.photos
  end

  def choose_hero
    if params[:place_id]
      @place = Place.find_by_slug(params[:place_id])
      @collect_photos = @place.photos.where.not(status: "removed")
    elsif params[:region_id]
      @region = Region.friendly.find(params[:region_id])
      @collect_photos = @region.photos.where.not(status: "removed")
    elsif params[:country_id]
      @country = Country.friendly.find(params[:country_id])
      @collect_photos = @country.photos.where.not(status: "removed")
    elsif params[:attraction_id]
      @attraction = Region.friendly.find(params[:attraction_id])
      @collect_photos = @attraction.photos.where.not(status: "removed")
    elsif params[:offer_id]
      @offer = Offer.friendly.find(params[:offer_id])
      @collect_photos = @offer.photos.where.not(status: "removed")
    elsif params[:story_id]
      @story = Story.friendly.find(params[:story_id])
      @collect_photos = @story.photos.where.not(status: "removed")
    end

      @photo = Photo.new
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    if @photo.photoable_type == "Offer"
      @offer = @photo.photoable
      @offer.photos << @photo
    end

    if @photo.save
      redirect_to :back, notice: "Photo added."
    else
      render :new
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to :back, notice: "Photo deleted"
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.update(photo_params)
      @photo.save
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: @photo }
    end
  end

  def import
    Photo.import(params[:file])
    redirect_to :back, notice: "Photos imported."
  end

  private
    def photo_params
      params[:photo].delete("path") if params[:photo][:path].blank?
      params.require(:photo).permit(
        :title, :path, :alt_tag, :credit, :place_id, :attraction_id,
        :photoable_id, :photoable_type, :caption, :caption_source,
        :customer_approved, :customer_review, :approved_at, :priority, :hero,
        :status, :country_hero, :country_include, :_destroy
      )
    end

end
