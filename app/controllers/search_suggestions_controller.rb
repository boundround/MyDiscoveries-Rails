class SearchSuggestionsController < ApplicationController

  def index
    @areas = SearchSuggestion.terms_for_area(search_params[:common], page: page_params(:areas_page), hitsPerPage: per_page_params(:per_page_areas) )
    @places = SearchSuggestion.terms_for_place(search_params[:common], page: page_params(:places_page), hitsPerPage: per_page_params(:per_page_places))
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
      params[resource_name] ||= 1
    end

    def per_page_params resource_name
      params[resource_name] ||= 4
    end
  


end
