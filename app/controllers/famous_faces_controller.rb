class FamousFacesController < ApplicationController
  def index
    @famous_faces = FamousFace.all
  end

  def show
    @famous_face = FamousFace.friendly.find(params[:id])
  end

  def new
    @famous_face = FamousFace.new
  end

  def all
    if params[:country_id]
      @country = Country.friendly.find(params[:country_id])
      variable = @country
    end

    @famous_faces = variable.famous_faces
  end

  def create
    @famous_face = FamousFace.new(famous_face_params)
    if params[:country_id]
      @famous_face.countries << Country.friendly.find(params[:country_id])
    end
    if @famous_face.save
      redirect_to :back, notice: "famous face added."
    else
      render :new
    end
  end

  def edit
    if params[:country_id]
      @country = Country.friendly.find(params[:country_id])
      variable = @country
    end

    @famous_face = FamousFace.find(params[:id])
  end

  def update
    @famous_face = FamousFace.find(params[:id])
    if @famous_face.update(famous_face_params)
      redirect_to :back
    end
  end

  def destroy
    @famous_face = FamousFace.find(params[:id])
    @famous_face.destroy
    if params[:country_id]
      @country = Country.friendly.find(params[:country_id])
      redirect_to all_country_famous_faces_path(@country), notice: "famous face deleted"
    else
      redirect_to :back, notice: "famous face deleted"
    end
  end


  private

    def famous_face_params
      params.require(:famous_face).permit(:name, :description, :photo, :photo_credit, :status, :_destroy)
    end
end
