class SearchRequestsController < ApplicationController
  
# info@boundround.com.

  def create
	search_request = SearchRequest.new(set_params)  	
  	
  	search_request.name = params[:name]
  	search_request.email = params[:email]
  	search_request.term = params[:term]
  	if search_request.save
  		NewSearchRequest.notification(search_request.name, search_request.email, search_request.term ).deliver
  		# render json: statusText[status: "success"]
  		render json: search_request
  	else
  		# render json: statusText[status: "error"]#search_request.errors.message
  		render json: search_request
  	end

  	
  end

  private

  def set_params
  	params.permit(:name, :email, :term)
  end

end
