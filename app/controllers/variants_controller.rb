class VariantsController < ApplicationController
  before_action -> { check_user_authorization('Spree::Variant') }
  before_action :set_product
  before_action :set_variant,
    except: [:fill_packages_options, :new, :create, :index]

  def show
  end

  def new
    @variant = @product.variants.build(
      departure_city: @product.locationStart
    )
  end

  def miscellaneous_charge
    @order    = Spree::Order.new
    @order.build_customer
  end

  def process_miscellaneous_charge
    response = Order::ProcessMiscellaneousCharge.call(
      order_params,
      credit_card_params,
      @variant
    )

    @order = response[:order]

    if response[:success]
      flash[:notice] = response[:message]
      redirect_to order_view_confirmation_path(@order)
    else
      flash.now[:alert] = response[:message]
      render :miscellaneous_charge
    end
  end

  def index
    @variants = Spree::Variant.where(product: @product, is_master: false)
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
      flash.now[:alert] = @variant.errors.full_messages.join(', ')
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
      flash.now[:alert] = @variant.errors.full_messages.join(', ')
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
    @variant = Spree::Variant.unscoped.find_by(product: @product, id: params[:id])
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
      :supplier_product_code,
      :miscellaneous_charges,
      :departure_date,
      :package_option,
      :accommodation
    )
  end

  def order_params
    params.require(:order).permit(
      :total,
      :description,
      customer_attributes: [
        :title,
        :email,
        :first_name,
        :last_name,
        :phone_number,
        :address_one,
        :address_two,
        :city,
        :country,
        :state,
        :postal_code
      ]
    )
  end

  def credit_card_params
    params.require(:order).require(:customer_attributes).require(:credit_card).permit(
      :number,
      :holder_name,
      :date,
      :cvv
    )
  end
end
