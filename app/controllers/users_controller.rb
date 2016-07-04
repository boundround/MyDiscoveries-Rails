require 'will_paginate/array'

class UsersController < ApplicationController

  before_action :redirect_if_not_admin, only: [:index, :draft_content]
  before_action :set_user, only: [:show, :public_profile, :edit,  :destroy, :update, :paginate_photos, :paginate_stories, :paginate_reviews]

  def index
    @set_body_class = 'white-body'
    @users = User.all
  end

  def show
    @set_body_class = 'br_tab'
    @active_points = true
    @stories = @user.stories.paginate(page: params[:stories_page], per_page: 4)

    verify_current_user

    @leaders = PointsBalance.order(balance: :desc).includes(:user).limit(20)
    @leaderboard = []
    @leaders.each do |leader|
      unless leader.user.roles.length > 0 || leader.user.admin
        @leaderboard.push leader
      end
    end
    @leaderboard = @leaderboard[0..3]
    @story = Story.new
    @user_photos = @story.user_photos.build
    @stories = @user.stories.paginate(page: params[:user_stories_page], per_page: 4)
    @reviews = @user.reviews.paginate(page: params[:user_reviews_page], per_page: 3)

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
    @owned_places = @user.owned_places

    verify_current_user

  end

  def update
    unless @user.update(user_params)
      flash[:error] = @user.errors.full_messages.join(" and ")
    end

    sign_in(@user)

    respond_to do |format|
        format.html { render :edit }
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

      @favorite_places = @user.favorite_places.where(is_area: false).paginate( page: params[:places_to_visit_page], per_page: params[:places_to_visit].nil?? 6 : 3 )
      @areas = @user.favorite_places.where(is_area: true).paginate(page: params[:areas_page], per_page: 3)
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

  def paginate_stories
    @stories = @user.stories.paginate(page: params[:user_stories_page], per_page: 4)
  end

  def videos
    if user_signed_in?
      @set_body_class = 'br_tab blue_page'
      @user = current_user
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end

  def games
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

  def resolvejs;end

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

    # page_1 = client.user_media_feed(777)
    # page_2_max_id = page_1.pagination.next_max_id
    # page_2 = client.user_recent_media(777, :max_id => page_2_max_id ) unless page_2_max_id.nil?
    # @html << "<h2>Page 1</h2><br/>"
    # for media_item in page_1
    #   @html << "<img src='#{media_item.images.thumbnail.url}'>"
    # end
    # @html << "<h2>Page 2</h2><br/>"
    # for media_item in page_2
    #   @html << "<img src='#{media_item.images.thumbnail.url}'>"
    # end
  end

  # def change_password

  #   user = current_user
  #   # Devise::Models::DatabaseAuthenticatable#update_with_password
  #   # Update record attributes when :current_password matches, otherwise returns error on :current_password.
  #   # It also automatically rejects :password and :password_confirmation if they are blank.
  #   # debugger
  #   if user.update_without_password(params[:user])

  #     # Sign in the user bypassing validation in case his password changed
  #     sign_in user, :bypass => true

  #     # redirect_to root_path, :notice => "Your Password has been updated!"
  #     render  json: {success:true}
  #   else

  #     # flash[:alert] = @user.errors.full_messages.join("<br />")
  #     render json: {success:true, messages: "Please check your input: #{user.errors.full_messages.to_sentence}" }

  # end

  # end
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
      params.require(:user).permit(:email, :admin, :name, :avatar, :country, :date_of_birth, :address, :first_name, :password, :password_confirmation, :is_private,
                                    :last_name, :address_line_2, :city, :state, :post_code, :promo_code, :username, :description,
                                    :role_ids => [], :owned_place_ids => [])
    end


    def verify_current_user
      unless @user == current_user || current_user.try(:admin)
        redirect_to root_path, notice: "Not Authorized!"
      end
    end

end
