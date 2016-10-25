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
      redirect_to choose_hero_place_path(@photo.photoable), notice: "Photo Succesfully Updated"
    else
      redirect_to choose_hero_place_path(@photo.photoable), notice: "Error"
    end
  end

  def attraction_update
    @photo = Photo.find(params[:id])
    if @photo.update(photo_params)
      redirect_to choose_hero_attraction_path(@photo.photoable), notice: "Attraction Succesfully Updated"
    else
      redirect_to choose_hero_attraction_path(@photo.photoable), notice: "Error"
    end
  end

  def all_photos
    if params[:place_id]
      @place = Place.friendly.find(params[:place_id])
    elsif params[:attraction_id]
      @attraction = Attraction.friendly.find(params[:attraction_id])
    end
    
    @photos = @place.photos
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    if params[:country_id]
      @photo.countries << Country.friendly.find(params[:country_id])
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
      params.require(:photo).permit(:title, :path, :alt_tag, :credit, :area_id, :place_id, :attraction_id, :photoable_id, :photoable_type, :caption, :caption_source,
                                    :customer_approved, :customer_review, :approved_at, :priority, :hero, :status, :country_hero, :country_include, :_destroy)
    end

end
