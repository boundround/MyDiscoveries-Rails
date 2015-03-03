class PuzzlesController < ApplicationController
  def index
    @params = params[:url]

    redirect_to params[:url]
  end
end
