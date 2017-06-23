class ProductsStickersController < ApplicationController
  include ApplicationHelper

  def create
    @product = Spree::Product.friendly.find(params[:product_id])
    @product.stickers = []

    redirect_to :back
  end

  def edit;end

  def update
    @product = Spree::Product.friendly.find(params[:product_id])
  end

  def index
    @stickers = Sticker.all
    @sticker = Sticker.new
  end

  def destroy

  end
end
