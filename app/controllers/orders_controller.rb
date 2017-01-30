class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:add_shopify_order_id]
  before_action :check_user_authorization, except: [:add_shopify_order_id]
  before_action :set_order, only: [:edit, :update, :checkout]
  before_action :set_offer, except: [:add_shopify_order_id, :download_pdf]

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
      redirect_to Order::Shopify::GetCheckoutUrl.call(@order)
    else
      flash.now[:alert] = "See problems below: " + @order.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit
  end

  def update
  end

  def download_pdf
    @order = Order.find_by(shopify_order_id: params[:shopify_order_id])
    if @order
      render json: { status: :success, body: { id: @order.id, title: @order.title } }
    else
      render json: { status: :not_found }
    end
  end

  def add_shopify_order_id
    request.body.rewind
    request_body = request.body.read
    request_hmac = env["HTTP_X_SHOPIFY_HMAC_SHA256"]

    verified     = VerifyShopifyWebhook.call(request_body, request_hmac)

    if verified
      response = Order::Shopify::AddOrderId.call(params)
      render json: response
    else
      render nothing: true, status: :unauthorized
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def set_offer
    @offer = Offer.friendly.find(params[:offer_id])
  end

  def order_params
    params.require(:order).permit(
      :title,
      :number_of_children,
      :number_of_infants,
      :number_of_adults,
      :start_date,
      :total_price,
      :request_installments
    )
  end
end
