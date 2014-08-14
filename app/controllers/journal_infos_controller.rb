class JournalInfosController < ApplicationController

  def show
    @journal_info = JournalInfo.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @journal_info }
    end
  end
end
