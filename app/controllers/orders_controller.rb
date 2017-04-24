class OrdersController < ApplicationController

  before_action :authenticate_user!
  before_action :check_user_authorization, except: [
    :index, :view_confirmation, :cms_edit, :cms_update, :customer_info
  ]
  before_action :set_order, only: [
    :edit, :update, :confirmation
  ]

  before_action :set_current_order, only: [
    :add, :populate, :delete_line_item,
    :add_passengers, :update_passengers,
    :checkout, :payment, :cart, :update_line_items,
    :empty
  ]

  before_action :set_offer, except: [
    :index,
    :view_confirmation,
    :cms_edit,
    :cms_update,
    :customer_info,
    :confirmation,
    :resend_confirmation,
    :cart,
    :empty,
    :checkout,
    :payment,
    :update_line_items
  ]

  before_action :set_customer, only: [:checkout, :payment]
  before_action :set_user, only: [
    :add_passengers, :update_passengers
  ]

  before_action :set_variants, only: [:add, :populate]
  before_action :set_line_items, only: [
    :add,
    :populate,
    :cart,
    :update_line_items
  ]

  before_action :set_line_item, only: [
    :add_passengers,
    :update_passengers
  ]

  before_action :set_order_for_admin, only: [
    :cms_update,
    :cms_edit,
    :view_confirmation,
    :customer_info,
    :resend_confirmation
  ]

  def index
    @orders = Spree::Order.where(authorized: true)
  end

  def cart
    associate_user
  end

  def update_line_items
    if @order.update(order_params)
      @order.set_cart_state! unless @order.total_quantity.to_i > 0
      @order.update!
      redirect_to cart_path
    else
      flash.now[:error] = @order.errors.full_messages.join(' ')
      redirect_to cart_path
    end
  end

  # Adds a new item to the order (creating a new order if none already exists)
  def populate
    populator = Spree::OrderPopulator.new(
      current_order(create_order_if_necessary: true),
      current_currency
    )

    if populator.populate(
        order_populate_params[:variant_id],
        order_populate_params[:quantity],
        order_populate_params[:options]
      )
      @line_item = current_order.line_items.find_by(
        variant_id: order_populate_params[:variant_id]
      )
      if order_populate_params[:request_installments] == "1"
        @line_item.set_request_installments!
      end
      current_order.set_cart_state!
      redirect_to line_item_add_passengers_path(@offer, @line_item)
    else
      flash.now[:error] = populator.errors.full_messages.join(" ")
      redirect_to :back
    end
  end

  def delete_line_item
    variant = Spree::Variant.find_by(id: params[:variant_id])
    if @order.contents.remove(variant, params[:quantity].to_i)
      @order.set_cart_state! if @order.line_items.empty?
      flash.now[:error] = variant.errors.full_messages.join(" ")
      redirect_to cart_path
    else
      flash.now[:notice] = "#{variant.select_label} successfully deleted"
      redirect_to cart_path
    end
  end

  def empty
    if @order.empty!
      @order.set_cart_state!
      redirect_to cart_path
    else
      flash.now[:error] = @order.errors.full_messages.join(" ")
      redirect_to cart_path
    end
  end

  def new
    @order = current_user.orders.build(
      product: @offer,
      title: @offer.name,
      number_of_adults: params[:number_of_adults].to_i
    )
  end

  def add
    associate_user
  end

  def create
    @order         = current_user.orders.build(order_params)
    @order.product = @offer

    if @order.save
      populator = Spree::OrderPopulator.new @order, current_currency
      redirect_to add_passengers_offer_order_path(@offer, @order)
    else
      flash.now[:alert] = "See problems below: " + @order.errors.full_messages.join(', ')
      render :new
    end
  end

  def customer_info
  end

  def checkout
    if @order.try(:px_payment?)
      @customer.credit_card = CreditCard.new

      respond_to do |format|
        format.html { render 'checkout' }
        format.json {
          render json: { status: :success, passenger: @order.passengers.first }
        }
      end
    else
      redirect_to cart_path
    end
  end

  def cms_edit
    @offer = @order.product
  end

  def cms_update
    @offer = @order.product
    if @order.update(order_params)
      flash[:notice] = "Order updated"
      render nothing: true
    else
      flash[:notice] = "Error"
    end
  end

  def confirmation
    redirect_to offers_path unless @order.completed?
    @customer   = @order.customer
  end

  def view_confirmation
    redirect_to :back unless @order.completed?
    @customer   = @order.customer
  end

  def resend_confirmation
    OrderAuthorized.delay.notification(@order.id)
    flash.now[:notice] = "Confirmation Re-sent"
    redirect_to :back
  end

  def payment
    redirect_to :cart unless @order.try(:px_payment?)
    @customer.credit_card = CreditCard.new(credit_card_params)
    credit_card_valid     = @customer.credit_card.valid?

    if @customer.update(customer_params) && credit_card_valid
      response = Payment::PaymentExpress::ProcessAuthRequest.call(@customer.credit_card, @order)
      if response[:success]
        @order.next if @order.px_payment?
        flash[:notice] = response[:message]
        redirect_to order_confirmation_path(@order)
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
    @order.next if @order.cart?
    build_passengers
  end

  def update_passengers
    if @line_item.update(line_item_params)
      @order.next
      redirect_to cart_path
    else
      flash.now[:alert] = "See problems below: " + @order.errors.full_messages.join(', ')
      render :add_passengers
    end
  end

  def update
    @order.assign_attributes(order_params)

    if @order.save
      redirect_to add_passengers_offer_order_path(@offer, @order)
    else
      flash.now[:alert] = "See problems below: " + @order.errors.full_messages.join(', ')
      render :edit
    end
  end

  private

  def build_passengers
    new_passengers_count = @line_item.quantity - @line_item.passengers.count
    new_passengers_count.times { @line_item.passengers.build(order: @order) }
  end

  def set_current_order
    @order = current_order || Spree::Order.incomplete.find_or_initialize_by(
      guest_token: cookies.signed[:guest_token]
    )
  end

  def set_customer
    @customer = @order.customer || @order.build_customer(user: current_user)
  end

  def set_user
    @user = current_user
  end

  def set_order_for_admin
    @order = Spree::Order.find_by(number: params[:id].upcase)
  end

  def set_order
    @order = current_user.orders.find_by(number: params[:id].upcase)
  end

  def set_offer
    @offer = Spree::Product.friendly.find(params[:offer_id])
  end

  def set_variants
    @variants = @offer.variants
  end

  def set_line_items
    line_item_ids = @order.line_items.pluck(:id)
    @line_items   = @offer ? @offer.line_items.where(id: line_item_ids) : @order.line_items
  end

  def set_line_item
    @line_item = @order.line_items.find_by(id: params[:line_item_id])
  end

  def order_params
    params.require(:order).permit(
      :title,
      :number_of_children,
      :number_of_infants,
      :number_of_adults,
      :start_date,
      :request_installments,
      line_items_attributes: [
        :id,
        :quantity
      ]
    )
  end

  def customer_params
    # doesn't include credit_card params for accept as customer relation(defined below)
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

  def order_populate_params
    params.require(:order_populate).permit(
      :options,
      :variant_id,
      :quantity,
      :request_installments,
      :maturity,
      :bed_type,
      :departure_city
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

  def line_item_params
    params.require(:line_item).permit(
      passengers_attributes: [
        :id,
        :title,
        :first_name,
        :last_name,
        :date_of_birth,
        :telephone,
        :mobile,
        :email,
        :order_id
      ]
    )
  end
end
