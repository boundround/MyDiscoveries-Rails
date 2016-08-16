class UserPhotosController < ApplicationController
  # before_filter :load_place_or_area, except: [:profile_create, :destroy]
  before_action :set_user_photo, only:[:show, :edit, :update, :destroy]

  def index
    @user_photos = Photo.all

    respond_to do |format|
      format.html
      format.json { render json: @user_photos }
    end
  end

  def show


    respond_to do |format|
      format.html
      format.json { render json: @user_photo }
    end
  end

  def new
    @user_photo = UserPhoto.new
  end

  def create
    @user_photo = UserPhoto.new(user_photo_params)
    if @user_photo.save
      if !@user_photo.story
        NewUserPhoto.notification(@user_photo).deliver
      end
      redirect_to :back, notice: "Thanks for the photo. We'll let you know when others can see it too!"
    else
      render :new
    end
  end

  def profile_create
    @user_photo = UserPhoto.new(user_photo_params)
    place = Place.find_by(place_id: @user_photo.google_place_id)
    if place && place.place_id != ""
      @user_photo.place = place
    end

    if @user_photo.save
      NewUserPhoto.notification(@user_photo).deliver
      respond_to do |format|
        format.html { redirect_to :back, notice: "Thanks for the photo. We'll let you know when others can see it too!" }
        format.json { render json: @user_photo }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, notice: "We're sorry. There was an error uploading your photo." }
        format.json { render json: @user_photo }
      end
    end
  end

  def destroy
    @user_photo.destroy
    redirect_to :back, notice: "Photo deleted"
  end

  def edit;end

  def update
    if params[:add_country]
      @user_photo.country_id = @user_photo.place.country_id
    else
      @user_photo.country_id = nil
    end
    if @user_photo.update(user_photo_params)
       # redirect_to place_user_photo_path(@user_photo.place, @user_photo)
       # redirect_to root_path
    end

    respond_to do |format|
      format.html { redirect_to :back }
    #   format.json { render json: @user_photo }
    end
  end

  def place_update
    @user_photo = UserPhoto.find(params[:id])
    if @user_photo.update(user_photo_params)
      redirect_to choose_hero_place_path(@user_photo.place), notice: "Photo Succesfully Updated"
    else
      redirect_to choose_hero_place_path(@user_photo.place), notice: "Error"
    end
  end

  def import
    Photo.import(params[:file])
    redirect_to :back, notice: "user_photos imported."
  end

  private
    def set_user_photo
        @user_photo = UserPhoto.find(params[:id])
    end

    def load_place_or_area
      resource, id = request.path.split("/")[1, 2]
      @place_or_area = resource.singularize.classify.constantize.friendly.find(id)
    end

    def user_photo_params
      params.require(:user_photo).permit(:title, :path, :caption, :hero, :story_id, :user_id,
                                        :place_id, :area_id, :status, :google_place_id, :alt_tag, :credit,
                                        :google_place_name, :instagram_id, :remote_path_url, :_destroy)
    end

end
