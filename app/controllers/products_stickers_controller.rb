class ProductsStickersController < ApplicationController
  include ApplicationHelper

  def create
    @product = Spree::Product.friendly.find(params[:product_id])
    @product.stickers = []

    redirect_to :back
  end

  def edit
  end

  def update
    @product = Spree::Product.friendly.find(params[:product_id])
  end

  def index
    @stickers = Sticker.all
    @offer = Spree::Product.friendly.find(params[:offer_id])
    @sticker = Sticker.new

    respond_to do |format|
      format.html
      format.json
    end
  end

  def destroy

  end
end
