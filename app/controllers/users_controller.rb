class UsersController < ApplicationController

  before_action :redirect_if_not_admin, only: [:edit, :index]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @set_body_class = 'passport-page'
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :admin, :name, :avatar)
    end

    def verify_current_user
      if current_user != User.find(params[:id])
        redirect_to root_path, notice: "Not Authorized!"
      end
    end

end
