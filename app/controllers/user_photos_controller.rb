class UserPhotosController < ApplicationController
  before_filter :load_place_or_area

  def index
    @user_photos = Photo.all

    respond_to do |format|
      format.html
      format.json { render json: @user_photos }
    end
  end

  def show
    @user_photo = Photo.find(params[:id])

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
      redirect_to @place_or_area, notice: "Thanks for the photo. We'll let you know when others can see it too!"
    else
      render :new
    end
  end

  def destroy
    @user_photo = UserPhoto.find(params[:id])
    @user_photo.destroy
    redirect_to :back, notice: "Photo deleted"
  end

  def edit
    @user_photo = UserPhoto.find(params[:id])
  end

  def update
    @user_photo = UserPhoto.find(params[:id])

    if @user_photo.update(user_photo_params)
      @user_photo.save
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: @user_photo }
    end
  end

  def import
    Photo.import(params[:file])
    redirect_to :back, notice: "user_photos imported."
  end

  private
    def load_place_or_area
      resource, id = request.path.split("/")[1, 2]
      @place_or_area = resource.singularize.classify.constantize.friendly.find(id)
    end

    def user_photo_params
      params.require(:user_photo).permit(:title, :path, :caption, :story_id, :user_id, :place_id, :area_id, :status, :_destroy)
    end

end
