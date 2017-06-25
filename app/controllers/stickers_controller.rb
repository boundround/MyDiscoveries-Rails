class StickersController < ApplicationController
  before_action :check_user_authorization, only: [:index, :create, :new, :update, :edit, :destroy, :show]

  def new
    @sticker = Sticker.new
    redirect_to stickers_path
  end

  def create
    @sticker = Sticker.new(sticker_params)

    if @sticker.save
      redirect_to :back, notice: "Sticker Created"
    else
      redirect_to :back, alert: @sticker.errors.full_messages.join(', ')
    end
  end

  def update
    @sticker = Sticker.find(params[:id])

    if @sticker.save
      redirect_to stickers_path, notice: "Sticker Updated"
    else
      render :new, notice: "Sorry, there was an error created your \"Sticker\"."
    end
  end

  def edit
    @sticker = Sticker.find(params[:id])
  end

  def destroy
    @sticker = Sticker.find(params[:id])
    @sticker.destroy
    redirect_to :back, notice: "Sticker deleted"
  end

  def index
    @stickers = Sticker.all
    @sticker = Sticker.new
  end

  def show
  end

  private
    def sticker_params
      params.require(:sticker).permit(:file)
    end
end
