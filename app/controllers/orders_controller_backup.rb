class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_authorization
  before_action :set_order, only: [
    :edit, :update, :checkout, :payment, :confirmation,
    :add_passengers, :edit_passengers, :update_passengers
  ]
  before_action :set_offer, except: :download_pdf
  before_action :check_order_authorized, only: [:edit, :checkout, :update, :payment]

  before_action :set_customer, only: [:checkout, :payment]

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
      @order.update_total_price!
      redirect_to add_passengers_offer_order_path(@offer, @order)
    else
      flash.now[:alert] = "See problems below: " + @order.errors.full_messages.join(', ')
      render :new
    end
  end

  def checkout
    @customer.credit_card = CreditCard.new()
  end

  def confirmation
    redirect_to offers_path unless @order.authorized?
    @operator   = @offer.operator
    @hero_photo = @order.offer.photos.where(hero: true).last
    @passengers = @order.passengers
    @customer   = @order.customer
  end

  def payment
    @customer.credit_card = CreditCard.new(credit_card_params)
    credit_card_valid     = @customer.credit_card.valid?

    if @customer.update(customer_params) && credit_card_valid
      response = Payment::PaymentExpress::ProcessAuthRequest.call(@customer.credit_card, @order)
      if response[:success]
        flash[:notice] = response[:message]
        redirect_to confirmation_offer_order_path(@offer, @order)
      else
        flash.now[:alert] = response[:message]
        render :checkout
      end
    else
      render :checkout
    end
  end

  def edit
  end

  def add_passengers
    @order.total_people_count.times { @order.passengers.build }
  end

  def edit_passengers
  end

  def update_passengers
    if @order.update(order_params)
      redirect_to checkout_offer_order_path(@offer, @order)
    else
      flash.now[:alert] = "See problems below: " + @order.errors.full_messages.join(', ')
      render :edit_passengers
    end
  end

  def update
    @order.assign_attributes(order_params)
    is_units_count_changed = is_units_count_changed?

    if @order.save
      @order.update_total_price!
      @order.passengers.destroy_all if is_units_count_changed
      redirect_to add_passengers_offer_order_path(@offer, @order)
    else
      flash.now[:alert] = "See problems below: " + @order.errors.full_messages.join(', ')
      render :edit
    end
  end

  def download_pdf
    @order = Order.find_by(shopify_order_id: params[:shopify_order_id])
    if @order
      render json: { status: :success, body: { id: @order.id, title: @order.title } }
    else
      render json: { status: :not_found }
    end
  end

  private

  def set_customer
    @customer = @order.customer || @order.build_customer(user: current_user)
  end

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def set_offer
    @offer = Offer.friendly.find(params[:offer_id])
  end

  def is_units_count_changed?
    @order.number_of_children_changed? ||
    @order.number_of_infants_changed?  ||
    @order.number_of_adults_changed?
  end

  def check_order_authorized
    redirect_to confirmation_offer_order_path(@offer, @order) if @order.authorized?
  end

  def order_params
    params.require(:order).permit(
      :title,
      :number_of_children,
      :number_of_infants,
      :number_of_adults,
      :start_date,
      :request_installments,
      passengers_attributes: [
        :id,
        :title,
        :first_name,
        :last_name,
        :date_of_birth,
        :telephone,
        :mobile,
        :email
      ]
    )
  end

  def customer_params
    params.require(:customer).permit(
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
      :postal_code,
      :is_primary
    )
  end

  def credit_card_params
    params.require(:customer).require(:credit_card).permit(
      :number,
      :holder_name,
      :date,
      :cvv
    )
  end
end
