class VideosController < ApplicationController
  def import
    Video.import(params[:file])
    redirect_to :back, notice: "Videos imported."
  end
end
