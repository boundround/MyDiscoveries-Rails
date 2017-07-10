class Order::ProcessMiscellaneousCharge
  include Service

  initialize_with_parameter_assignment :order_params,
    :credit_card_params, :order_type_params, :variant

  def call
    process
    response
  end

  private

  def response
    {
      success: transaction_valid?,
      message: response_message,
      order:   order || Spree::Order.new(order_params)
    }
  end

  def order
    @order ||= if selected_order_type?
      check_selected_order_present
      selected_order
    else
      Spree::Order.new(order_params)
    end
  end

  def credit_card_valid?
    @credit_card_valid ||= order.customer.credit_card.valid?
  end

  def assign_credit_card
    order.customer.credit_card = CreditCard.new(credit_card_params)
  end

  def process_order
    order.line_items.find_by(variant: variant).update(price: order_params[:total])

    order.set_miscellaneous_charges!
    order.update!
  end

  def payment_express_response
    @payment_express_response ||= Payment::PaymentExpress::ProcessAuthRequest.call(
      order.customer.credit_card,
      order.reload,
      order_type_params[:order_type]
    )
  end

  def errors
    @errors ||= []
  end

  def response_message
    if transaction_valid?
      payment_express_response[:message]
    else
      errors.join(', ')
    end
  end

  def transaction_valid?
    @transaction_valid ||= errors.empty?
  end

  def set_order_completed
    if payment_express_response[:success]
      order.set_completed_state!
    else
      errors << payment_express_response[:message]
    end
  end

  def process_order_errors
    if !order.valid?
      errors << order.errors.full_messages
    end
  end

  def process_credit_card_errors
    if !order.customer.credit_card.valid?
      errors << order.customer.credit_card.errors.full_messages
    end
  end

  def assign_customer
    order.assign_attributes(
      customer_attributes: order_params[:customer_attributes]
    )
  end

  def process
    return nil if order.nil?

    assign_customer if selected_order_type?
    assign_credit_card

    if order.save && credit_card_valid? && order.contents.add(variant, 1)
      process_order
      assign_credit_card
      set_order_completed
    else
      process_order_errors
      process_credit_card_errors
    end
  end

  def selected_order_type?
    @selected_order_type ||= order_type_params[:order_type] == 'created_order'
  end

  def selected_order
    @selected_order ||= Spree::Order.find_by(id: order_type_params[:selected_order])
  end

  def check_selected_order_present
    if selected_order_type? & selected_order.nil?
      errors << "Selected order can't be empty"
    end
  end
end
