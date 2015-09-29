class UsersController < ApplicationController

  before_action :redirect_if_not_admin, only: [:index]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @set_body_class = 'passport-page'

    verify_current_user

  end

  # GET /users/new
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    respond_to do |format|
      format.html { redirect_to user_path(current_user) }
      format.json { render :show, status: :ok, location: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @set_body_class = 'passport-page'
    @user = User.find(params[:id])
    @owned_places = @user.owned_places

    verify_current_user

  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update(user_params)
        if @user == current_user
          format.html { redirect_to user_path(current_user) }
          format.js
        else
          format.html { redirect_to users_path }
          format.js
        end
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])

    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def photos
    if user_signed_in?
      @set_body_class = 'passport-page'
      @user = current_user
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end

  def videos
    if user_signed_in?
      @set_body_class = 'passport-page'
      @user = current_user
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end

  def games
    if user_signed_in?
      @set_body_class = 'passport-page'
      @user = current_user
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end

  def places
    if user_signed_in?
      @set_body_class = 'passport-page'
      @user = current_user
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end

  def fun_facts
    if user_signed_in?
      @set_body_class = 'passport-page'
      @user = current_user
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end

  def stories
    if user_signed_in?
      @set_body_class = 'passport-page'
      @user = current_user
      @story = Story.new
      @user_photos = @story.user_photos.build
    else
      redirect_to new_user_registration_path, notice: "You must be logged in to view that"
    end
  end

  def reviews
    if user_signed_in?
      @set_body_class = 'passport-page'
      @user = current_user
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
    @places = Place.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :admin, :name, :avatar, :country, :date_of_birth, :address, :first_name,
                                    :last_name, :address_line_2, :city, :state, :post_code, :promo_code, :username,
                                    :role_ids => [], :owned_place_ids => [])
    end

    def verify_current_user
      unless @user == current_user || current_user.try(:admin)
        redirect_to root_path, notice: "Not Authorized!"
      end
    end

end
