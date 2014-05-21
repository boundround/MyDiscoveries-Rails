class AreasController < ApplicationController
  def index
    @areas = Area.all

    # geojson for MapBox map
    @geojson = Array.new

    @areas.each do |area|
      @geojson << {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [area.longitude, area.latitude]
        },
        properties: {
          "icon" => {
            "iconUrl" => ActionController::Base.helpers.asset_path("marmite.JPG", type: :image),
            # size of the icon
            "iconSize" => [50, 50],
            # point of the icon which will correspond to marker location
            "iconAnchor" => [25, 25],
            # point from which the popup should open relative to the iconAnchor
            "popupAnchor" => [0, -25],
          }
        }
        # address: area.address,
        # :'marker-color' => '#00607d',
        # :'marker-symbol' => 'airplane',
        # :'marker-size' => 'medium'
        # }
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: @geojson }  # respond with the created JSON object
    end
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
      if @area.update(area_update_params)
        redirect_to 'areas#index'
      else
        format.html { render :edit }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  def mercury_update
    area = Area.find(params[:id])
    area.description = params[:content]['area-content'][:value]
    area.save!
    render text: ""
  end


  private
    def area_params
      params.require(:area).permit(:code, :identifier, :display_name, :country, :short_intro, :description, :latitude, :longitude, :address, photos_attributes: [:id, :title, :path, :credit])
    end

    def area_update_params
      params.require(:area).permit(:code, :identifier, :display_name, :country, :short_intro, :description, :latitude, :longitude, :address, photo: [:id, :title, :path, :credit, :area_id])
    end
end
