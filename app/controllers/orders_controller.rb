class OrdersController < ApplicationController
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
      redirect_to checkout_offer_order_path(@offer, @order), notice: 'Order successfully created'
    else
      flash.now[:alert] = "See problems below: " + @order.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit
  end

  def update
  end

  def checkout
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
end
