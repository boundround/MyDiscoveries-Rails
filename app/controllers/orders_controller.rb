class OrdersController < ApplicationController
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Order

  before_action :authenticate_user!
  before_action :check_user_authorization, except: [
    :index, :view_confirmation, :cms_edit, :cms_update, :customer_info
  ]
  before_action :set_order, only: [
    :edit, :update, :checkout, :payment, :confirmation,
    :add_passengers, :edit_passengers, :update_passengers
  ]
  before_action :set_offer, except: [
    :index, :view_confirmation, :cms_edit, :cms_update, :customer_info
  ]
  before_action :check_order_authorized, only: [:edit, :checkout, :update, :payment]

  before_action :set_customer, only: [:checkout, :payment]
  before_action :set_user, only:[:add_passengers, :update_passengers, :edit_passengers]

  def index
    @orders = Spree::Order.where(authorized: true)
  end

  def new
    @order = current_user.orders.build(
      product: @offer,
      title: @offer.name,
      number_of_adults: params[:number_of_adults].to_i
    )
  end

  def create
    @order         = current_user.orders.build(order_params)
    @order.product = @offer

    if @order.save
      @order.update_total_price!
      populator = Spree::OrderPopulator.new @order, current_currency
      # @order.varinats.each{ |v| populator.populate(v.id, 1) }

      redirect_to add_passengers_offer_order_path(@offer, @order)
    else
      flash.now[:alert] = "See problems below: " + @order.errors.full_messages.join(', ')
      render :new
    end
  end

  def customer_info
    @order = Spree::Order.find(params[:id])
  end

  def checkout
    @customer.credit_card = CreditCard.new()

    respond_to do |format|
      format.html {render "checkout"}
      format.json { render json: { status: :success, passenger: @order.passengers.first } }
    end
  end

  def cms_edit
    @order = Spree::Order.find(params[:id])
    @offer = @order.product
  end

  def cms_update
    @order = Spree::Order.find params[:id]
    @offer = @order.product
    if @order.update(order_params)
      flash[:notice] = "Order updated"
      render nothing: true
    else
      flash[:notice] = "Error"
    end
  end

  def confirmation
    if @order.product.test_product
      @operator   = @offer.operator
      @hero_photo = @offer.photos.where(hero: true).last
      @customer   = @order.customer
      debugger
    else
      redirect_to offers_path unless @order.authorized?
      @operator   = @offer.operator
      @hero_photo = @offer.photos.where(hero: true).last
      @customer   = @order.customer
    end
  end

  def view_confirmation
    @order = Spree::Order.find(params[:id])
    @offer = @order.product
    redirect_to offers_path unless @order.authorized?
    @operator   = @offer.operator
    @hero_photo = @order.product.photos.where(hero: true).last
    @customer   = @order.customer
  end

  def resend_confirmation
    OrderAuthorized.delay.notification(params[:order_id])
    flash.now[:notice] = "Confirmation Re-sent"
    render nothing: true
  end

  def payment
    if @offer.test_product
      @customer.credit_card = CreditCard.new(credit_card_params)
      if @customer.update(customer_params)
        @order.save!
        debugger
        redirect_to confirmation_offer_order_path(@offer, @order)
      end
    else
      @customer.credit_card = CreditCard.new(credit_card_params)
      credit_card_valid     = @customer.credit_card.valid?

      if @customer.update(customer_params) && credit_card_valid
        @order.save!
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
  end

  def edit
  end

  def add_passengers
    @order.total_people_count.times { @order.passengers.build }
  end

  def edit_passengers
    @passengers = @order.passengers.order(id: :asc)
  end

  def update_passengers
    if @order.update(order_params)
      @user.update(user_params)

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

  private

  def set_customer
    @customer = @order.customer || @order.build_customer(user: current_user)
  end

  def set_user
    @user = current_user
  end

  def set_order
    @order = current_user.orders.find_by(number: params[:id].upcase)
  end

  def set_offer
    @offer = Spree::Product.friendly.find(params[:offer_id])
  end

  def is_units_count_changed?
    @order.number_of_children_changed? ||
    @order.number_of_infants_changed?  ||
    @order.number_of_adults_changed?
  end

  def check_order_authorized
    unless @order.product.test_product
      redirect_to confirmation_offer_order_path(@offer, @order) if @order.authorized?
    end
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

  def user_params
    user_first = order_params[:passengers_attributes][:"0"]
    user_first.delete("id")
    user_first[:gender] = user_first.delete(:title)
    user_first[:home_phone] = user_first.delete(:telephone)
    user_first
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
      :is_primary,
      :credit_card => [
        :number,
        :holder_name,
        :date,
        :cvv
      ]
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
