class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_authorization
  before_action :set_order, only: [ :edit, :update, :checkout ]
  before_action :set_offer

  def new
    @order = current_user.orders.build(
      offer: @offer,
      title: @offer.name,
      number_of_adults: params[:number_of_adults].to_i
    )
  end

  def create
    @order       = current_user.orders.build(order_params)
    @order.offer = @offer

    if @order.save
      redirect_to checkout_url
    else
      flash.now[:alert] = "See problems below: " + @order.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit
  end

  def update
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def set_offer
    @offer = Offer.find(params[:offer_id])
  end

  def order_params
    params.require(:order).permit(
      :title,
      :number_of_children,
      :number_of_infants,
      :number_of_adults,
      :start_date,
      :total_price
    )
  end

  # TODO: refactor
  def checkout_url
    parameters = [
      ['Adult', :number_of_adults],
      ['Child', :number_of_children],
      ['Infant', :number_of_infants]
    ].map do |age_type, quantity_column|
      variant = @order.offer.shopify_product.variants.detect do |variant|
        variant.option1 == age_type
      end
      quantity = @order.send(quantity_column)
      "#{variant.id}:#{quantity}" if quantity != 0
    end.compact.join(',')
    "https://#{ENV['SHOPIFY_STORE_DOMAIN']}/cart/#{parameters}"
  end
end
