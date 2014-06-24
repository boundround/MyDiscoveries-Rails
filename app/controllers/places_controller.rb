class PlacesController < ApplicationController
  def index
    @places = Place.all

    # geojson for MapBox map
    @places_geojson = Place.all_geojson

    respond_to do |format|
      format.html
      format.json { render json: @places_geojson }  # respond with the created JSON object
    end
  end

  def show
  end

  def create
  end

  def new
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
