class SearchSuggestionsController < ApplicationController

  def index
    render json: SearchSuggestion.terms_for(search_params[:common])
  end

  private

  	def search_params
  		params[:search] ||= {}
  	end
  


end
