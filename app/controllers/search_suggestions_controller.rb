class SearchSuggestionsController < ApplicationController

  include Locatable

  def index
    @areas = SearchSuggestion.terms_for_area(search_params[:common], page: page_params(:areas_page), facets: 'area', facetFilters: ['area:t'], hitsPerPage: per_page_params(:per_page_areas) )
    @places = SearchSuggestion.terms_for_place(search_params[:common], page: page_params(:places_page), facets: 'area', facetFilters: ['area:f'], hitsPerPage: per_page_params(:per_page_places))
    respond_to do |f|
      f.html
      f.js
    end
  end

  def nearby
    @places= Place.includes(:photos, :primary_category, :subcategories, :country).near(current_user_location, 100000).paginate(page: params[:page], per_page: 6)
    #@places= Place.includes(:photos, :primary_category, :subcategories, :country).all.paginate(page: params[:places_page], per_page: 6)
    respond_to do |f|
      f.html
      f.js 
    end
  end

  private

  	def search_params
  		params[:search] ||= {}
  	end

    def page_params resource_name
      params[resource_name] ||= 0
    end

    def per_page_params resource_name
      params[resource_name] ||= 4
    end
  


end
