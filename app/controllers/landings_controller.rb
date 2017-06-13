class LandingsController < ApplicationController

	before_action :set_landing, only: [:edit, :update, :destroy]
  before_action :check_user_authorization
  
  def index
    @landings = Landing.all
  end

  def new
  	@landing = Landing.new()
  end

  def create
  	@landing = Landing.new(landing_params)

  	if !@landing.unique_routes(params[:landing][:from_url])
	    if @landing.save
	      respond_to do |format|
	        format.html { redirect_to landings_path, notice: 'Landing succesfully created.' }
	        format.json { render :show, status: :ok, location: @landing }
	      end
	    else
	      render action: 'new'
	    end
	  else
	  	flash[:error] = "Opss! From url has been taken."
      render action: 'new'
    end
  end

  def edit;end

  def update
  	if !@landing.unique_routes(params[:landing][:from_url])
	  	if @landing.update(landing_params)
	      respond_to do |format|
	        format.json { render json: @landing }
	        format.html do
	          redirect_to landings_path, notice: 'Landing succesfully updated'
	        end
	      end
	    else
	      redirect_to :back
	    end
	  else
	  	flash[:error] = "Opss! From url has been taken."
      redirect_to :back
    end
  end

  def destroy
    @landing.destroy
    redirect_to landings_path, notice: "Landing Deleted"
  end

  private
  def set_landing
  	@landing = Landing.find(params[:id])
  end

  def landing_params
  	params.require(:landing).permit(:from_url, :to_url)
  end
end
