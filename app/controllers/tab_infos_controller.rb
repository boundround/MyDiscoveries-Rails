class TabInfosController < ApplicationController
  
  def all
    if params[:place_id]
      @place = Place.friendly.find(params[:place_id])
      variable = @place
    end

    @tab_infos = variable.tab_infos
    @tab_info  = TabInfo.new()
  end

  def create
    @tab_info = TabInfo.new(tab_info_params)

    if @tab_info.save
      redirect_to :back, notice: "Tab Info Created"
    else
      redirect_to :back, notice: "Sorry, there was an error created your \"Tab Info\"."
    end
  end

  def update
    @tab_info = TabInfo.find(params[:id])
    @place = Place.friendly.find(params[:place_id])

    if @tab_info.update(tab_info_params)
      redirect_to all_place_tab_infos_path(@place), notice: "Tab Info Updated"
    else
      render "edit", notice: "Sorry, there was an error updating this tab info"
    end
  end

  def destroy
    @tab_info = TabInfo.find(params[:id])
    @place = Place.friendly.find(params[:place_id])
    @tab_info.destroy
    redirect_to all_place_tab_infos_path(@place), notice: "Tab Info Deleted"
  end

  def edit
    @place = Place.friendly.find(params[:place_id])
    @tab_info = TabInfo.find(params[:id])
  end

  private
  def tab_info_params
    params.require(:tab_info).permit(:title, :description, :image, :tab_infoable_id, :tab_infoable_type)
  end
  
end
