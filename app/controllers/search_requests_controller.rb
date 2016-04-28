class SearchRequestsController < ApplicationController
  
# info@boundround.com.

  def create
	search_request = SearchRequest.new(set_params)  	
  	
  	search_request.name = params[:name]
  	search_request.email = params[:email]
  	search_request.term = params[:term]
  	if search_request.save
  		NewSearchRequest.notification(search_request.name, search_request.email, search_request.term ).deliver
  		render json: { success:true } 
  	else
  		render json: { success:false, messages: "Please check your input: #{search_request.errors.full_messages.to_sentence}" }
  	end

  	
  end

  private

  def set_params
  	params.permit(:name, :email, :term)
  end

end
