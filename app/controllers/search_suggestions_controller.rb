class SearchSuggestionsController < ApplicationController

  #backup
  def index
    render json: SearchSuggestion.terms_for(params[:term])
  end
  #backup end
  


end
