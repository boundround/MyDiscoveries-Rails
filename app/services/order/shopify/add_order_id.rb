class Order::Shopify::AddOrderId
  include Service

  initialize_with_parameter_assignment :params

  def call
    response
  end

  private

  def response
    if valid_params?
      order.update(shopify_order_id: shopify_order_id)

      if order_paid?
        order.paid!
      else
        order.created_in_shopify!
      end

      { status: :success }
    else
      {
        status: :unprocessable_entity,
        errors: @errors.join(', ')
      }
    end
  end

  def valid_params?
    @errors  = []
    valid = false

    if order_id.blank?
      @errors << "Order ID can't be empty"
    elsif order.blank?
      @errors << "Order not found with order_id: #{order_id}"
    elsif shopify_order_id.blank?
      @errors << "Shopify Order ID can't be empty"
    else
      valid = true
    end

    valid
  end

  def order_paid?
    order.shopify_order.try(:financial_status) == 'paid'
  end

  def order
    @order ||= Order.find(order_id)
  end

  def order_id
    @order_id ||= params['landing_site'].partition('boundround_order_id=').last if params['landing_site']
  end

  def shopify_order_id
    @shopify_order_id ||= params['id']
  end
end
