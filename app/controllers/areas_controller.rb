class AreasController < ApplicationController
  def index
    @areas = Area.all
  end

  def show
    @area = Area.find(params[:id])
  end

  def create
    @area = Area.new(area_params)

    if @area.save
      redirect_to(areas_path, notice: 'Area succesfully saved')
    else
      redirect_to 'areas#new'
    end
  end

  def new
    @area = Area.new
    @area.photos.build

  end

  def edit
    @area = Area.find(params[:id])

  end


  def update
    @area = Area.find(params[:id])

    respond_to do |format|
      if @area.update(area_params)
        format.html { redirect_to @area, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @area }
      else
        format.html { render :edit }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private
    def area_params
      params.require(:area).permit(:code, :identifier, :display_name, :country, :short_intro, :description, :address, photos_attributes: [:id, :title, :path, :credit])
    end
end
