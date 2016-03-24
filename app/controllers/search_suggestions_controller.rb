class SearchSuggestionsController < ApplicationController

  def index
    # render json: SearchSuggestion.terms_for(search_params[:common])
     # @places = SearchSuggestion.terms_for(search_params[:common]).first[1]
     @areas = SearchSuggestion.terms_for_area(search_params[:common]).first[1]
     @places = SearchSuggestion.terms_for_place(search_params[:common]).first[1]
     # @datas = SearchSuggestion.terms_for(search_params[:common])
     # @places = 
  end

  private

  	def search_params
  		params[:search] ||= {}
  	end
  


end
