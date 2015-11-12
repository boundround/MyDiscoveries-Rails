class PointsValuesController < ApplicationController
  def index
    @set_body_class = 'white-body'
    @points_values = PointsValue.all
    @points_value = PointsValue.new

    respond_to do |format|
      format.html
      format.json { render json: @points_values }
    end
  end

  def show
    @points_value = PointsValue.find(params(:id))

    respond_to do |format|
      format.html
      format.json { render json: @points_value }
    end
  end

  def edit
    @points_value = PointsValue.find(params(:id))
  end

  def create
    @points_value = PointsValue.new(points_value_params)
    if @points_value.save
      redirect_to :back, notice: "points_value added."
    else
      render :new
    end
  end

  def new
    @points_value = PointsValue.new
  end

  def destroy
    @points_value = PointsValue.find(params[:id])
    @points_value.destroy
    redirect_to :back, notice: "Value deleted"
  end

  def update
  end

  private

    def points_value_params
      params.require(:points_value).permit(:asset_type, :value, :_destroy)
    end
end
