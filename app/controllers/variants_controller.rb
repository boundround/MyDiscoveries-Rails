class VariantsController < ApplicationController
  before_action -> { check_user_authorization('Spree::Variant') }
  before_action :set_product
  before_action :set_variant, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @variant = @product.variants.build(
      track_inventory: false,
      departure_city: @product.locationStart
    )
  end

  def index
    @variants = @product.variants
  end

  def fill_packages_options
    result = Variant::FindPackagesOptions.call(@product, params)
    @variants         = result[:variants]
    @options_selected = result[:options_selected]
  end

  def create
    @variant = @product.variants.build(variant_params)
    if @variant.save
      redirect_to(
        offer_variants_path(offer: @offer),
        notice: 'Variant succesfully saved'
      )
    else
      flash.now[:alert] = 'Product not saved!'
      render :new
    end
  end

  def edit
  end

  def update
    if @variant.update(variant_params)
      redirect_to(
        offer_variants_path(offer: @offer),
        notice: "Variant Updated"
      )
    else
      flash.now[:alert] = 'Sorry, there was an error updating this Variant'
      render :edit
    end
  end

  def destroy
    @variant.destroy
    redirect_to(
      offer_variants_path(offer: @offer),
      notice: "Variant Deleted"
    )
  end

  private

  def set_product
    @product = Spree::Product.friendly.find(params[:offer_id])
  end

  def set_variant
    @variant = @product.variants.find(params[:id])
  end

  def variant_params
    params.require(:variant).permit(
      :id,
      :sku,
      :product_id,
      :price,
      :track_inventory,
      :departure_city,
      :item_code,
      :bed_type,
      :maturity,
      :stock_items_count,
      :sumcode,
      :item_code,
      :description,
      :room_type,
      :supplier_product_code
    )
  end
end
