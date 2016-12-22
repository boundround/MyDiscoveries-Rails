require 'will_paginate/array'

class UsersController < ApplicationController

  before_action :redirect_if_not_admin, only: [:index, :draft_content]
  before_action :set_user, only: [:show, :public_profile, :edit,  :destroy, :update, :paginate_photos, :paginate_stories, :paginate_reviews]
  before_action :check_user_authorization, only: [:index, :show]

  def index
    @set_body_class = 'white-body'
    @users = User.all
  end

  def show
    @set_body_class = 'br_tab'

    verify_current_user

    @stories = @user.stories.paginate(page: params[:user_stories_page], per_page: 4)
    @reviews = @user.reviews.paginate(page: params[:user_reviews_page], per_page: 3)
    @orders  = @user.orders.last(2)
    @countries = Country.all
  end

  def public_profile
    @stories = @user.stories.paginate(page: params[:stories_page], per_page: 4)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      respond_to do |format|
        format.html { redirect_to user_path(current_user) }
        format.json { render :show, status: :ok, location: @user }
      end
    else
      render action: 'new'
    end
  end

  # GET /users/1/edit
  def edit
    @set_body_class = 'passport-page'
    # @owned_places = @user.owned_places

    verify_current_user

  end

  def update
    unless @user.update(user_params)
      flash[:error] = @user.errors.full_messages.join(" and ")
    end

    sign_in(@user) if current_user == @user

    respond_to do |format|
        format.html { redirect_to @user }
        format.json { render json: @user }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def favourites
    if user_signed_in? || current_user.admin?
      @user = User.includes(:favorite_places).find(params[:id])
      @places_to_visit = @user.favorite_attractions.paginate( page: params[:places_to_visit_page], per_page: 3)
      @areas = @user.favorite_places.paginate(page: params[:areas_page], per_page: 3)
      @stories = @user.user_stories.paginate(page: params[:stories_page], per_page: 4)
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end


  def photos
    if user_signed_in? || current_user.admin?
      @user = User.includes(:user_photos).find(params[:id])
      @photos = @user.user_photos.paginate(:page => params[:active_photos], per_page:12)
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end


  def paginate_reviews
    @reviews = @user.reviews.paginate(:page => params[:active_reviews_user], per_page: 3)
  end

  def paginate_photos
    @photos = @user.user_photos.paginate(:page => params[:active_photos], per_page:12)
  end

  def paginate_places
    @user = User.includes(:favorite_places).find(params[:id])
    @areas = @user.favorite_places.paginate(page: params[:areas_page], per_page: 3)
  end

  def paginate_place_to_visit
    @user = User.includes(:favorite_places).find(params[:id])
    @places_to_visit = @user.favorite_attractions.paginate( page: params[:places_to_visit_page], per_page: 3)
  end

  def paginate_stories
    if !params[:stories_page].blank?
      @user = User.includes(:favorite_places).find(params[:id])
      @stories = @user.user_stories.paginate(page: params[:stories_page], per_page: 4)
    else
      @stories = @user.stories.paginate(page: params[:user_stories_page], per_page: 4)
    end
  end

  def videos
    if user_signed_in?
      @set_body_class = 'br_tab blue_page'
      @user = current_user
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end

  def places
    if user_signed_in?
      @set_body_class = 'br_tab blue_page'
      @user = current_user
      @active_wishlist = true
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end

  def fun_facts
    if user_signed_in?
      @set_body_class = 'br_tab blue_page'
      @user = current_user
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end

  def stories
    if user_signed_in? || current_user.admin?
      @user = User.includes(:stories).find(params[:id])
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end

  def reviews
    if user_signed_in? || current_user.admin?
      @user = User.includes(:reviews).find(params[:id])
      @reviews = @user.reviews.paginate(:page => params[:active_reviews_user], per_page:6)
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end

  def send_story
    @uploaded_files = []
    @uploaded_files << params[:file1]
    @uploaded_files << params[:file2]
    @uploaded_files << params[:file3]

    if UserStory.send_story(params[:user_email], params[:user_name], params[:story_text], params[:formatted_address], @uploaded_files).deliver
      redirect_to :back
      flash[:notice] = "Mail delivered. Thanks!"
    else
      flash[:notice] = "Oops. There was a problem sending your email."
    end
  end

  def draft_content
    @stories = Story.where(status: "draft")
    @user_photos = UserPhoto.where('story_id IS NULL').where(status: "draft")
    @reviews = Review.where(status: "draft")
    @users = User.order(:username)
    @places = Place.order(:display_name)
  end

  def instagram_feed
    @set_body_class = 'br_tab blue_page'
    @user = current_user
    @instagram_identity = @user.identities.where(provider: "instagram").first

    if @instagram_identity
      client = Instagram.client(:access_token => session[:access_token])

      @posts = client.user_recent_media(@instagram_identity.uid, count: 1000)
    end
  end

  def leaderboard
    @set_body_class = "white-body"
    @points_balances = PointsBalance.order(balance: :desc).includes(:user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      role = Role.where(name: "contributor").first.id
      if params[:user][:role_ids]
        if params[:user][:role_ids].include?(role.to_s) && params[:user][:is_private].include?("1")
          params[:user][:is_private] = "0"
        end
      end

      if params[:user][:is_private]=='on' && !params[:user][:is_private].blank?
        params[:user][:is_private]=true
      else
        params[:user][:is_private]=false
      end

      params.require(:user).permit(:email, :admin, :name, :avatar, :country, :date_of_birth, :address, :first_name, :password, :password_confirmation, :is_private, :gender, :mobile,
                                    :last_name, :address_line_2, :city, :state, :post_code, :promo_code, :username, :description, :min_age, :max_age,
                                    :role_ids => [], :owned_place_ids => [])
    end


    def verify_current_user
      unless @user == current_user || current_user.try(:admin)
        redirect_to root_path, notice: "Not Authorized!"
      end
    end

end
