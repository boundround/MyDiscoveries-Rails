class SearchQueriesController < ApplicationController

  def create

    @search_query = SearchQuery.new(search_query_params)

    if @search_query.save
    redirect_to :back
    end
    
  end

  private
    def search_query_params
      params.require(:search_query).permit(:term, :city, :country)
    end


end
