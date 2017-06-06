class LandingsController < ApplicationController

	before_action :set_user
	before_action :set_landing, only: [:edit, :update, :destroy]

  def index
    @landings = @user.landings
  end

  def new
  	@landing = @user.landings.build
  end

  def create
  	@landing = @user.landings.build(landing_params)

  	if !@landing.unique_routes(params[:landing][:from_url])
	    if @landing.save
	      respond_to do |format|
	        format.html { redirect_to user_landings_path(@user), notice: 'Landing succesfully created.' }
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
	          redirect_to user_landings_path(@user), notice: 'Landing succesfully updated'
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
    redirect_to user_landings_path(@user), notice: "Landing Deleted"
  end

  private
  def set_user
  	@user =  User.find(params[:user_id])
  end

  def set_landing
  	@landing = @user.landings.find(params[:id])
  end

  def landing_params
  	params.require(:landing).permit(:from_url, :to_url, :user_id )
  end
end
