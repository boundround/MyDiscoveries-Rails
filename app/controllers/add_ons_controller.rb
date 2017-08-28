class AddOnsController < ApplicationController
  before_action -> { check_user_authorization('Spree::AddOn') }
  before_action :set_product
  before_action :set_add_on, only: [:edit, :update, :destroy]

  def index
    @add_ons = @product.add_ons
  end

  def new
    @add_on = @product.add_ons.build
  end

  def create
    if @product.add_ons.create(add_on_params)
      redirect_to(
        offer_add_ons_path(@product),
        notice: 'Add-On succesfully created'
      )
    else
      render :new
    end
  end

  def update
    if @add_on.update(add_on_params)
      redirect_to(
        offer_add_ons_path(@product),
        notice: 'Add-On successfully updated'
      )
    else
      render :edit
    end
  end

  def destroy
    @add_on.destroy
    redirect_to(
      offer_add_ons_path(@product),
      notice: 'Add-On Deleted'
    )
  end

  private

  def set_product
    @product = Spree::Product.friendly.find(params[:offer_id])
  end

  def set_add_on
    @add_on = Spree::AddOn.find(params[:id])
  end

  def add_on_params
    params.require(:add_on).permit(
      :item_code,
      :name,
      :description,
      :amount,
      :active_for_admin
    )
  end
end
