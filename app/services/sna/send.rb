require 'httparty'

class SNA::Send
  include Service

  initialize_with_parameter_assignment :order

  def call
    process
  end

  def print
    JSON.pretty_generate(JSON.parse(order_body))
  end

  private

  def customer
    @customer ||= order.customer
  end

  def user
    @user ||= User.find_by id: order.user_id
  end

  def order_date
    @order_date ||= order.created_at.strftime('%Y-%m-%d')
  end

  def order_time
    @order_time ||= order.created_at.strftime('%H:%M:%S')
  end

  def shipping_cost
    '0'
  end

  def process
    response = HTTParty.post(
      ENV['SNA_WEBHOOK_URL'],
      basic_auth: credentials,
      headers: { 'Accept' => 'application/json' },
      body: order_body)
  end

  def credentials
    { username: ENV['SNA_USERNAME'], password: ENV['SNA_PASSWORD'] }
  end

  def order_body
    Jbuilder.encode do |json|
      json.Envelope do
        json.Order do
          json.CustAccount user.ax_cust_account
          json.SalesId order.ax_sales_id
          json.OrderDate order_date
          json.OrderTime order_time
          json.EmailAddress customer.try(:email).presence || 'noemail@snatours.com'
          json.ShippingCost shipping_cost
          json.ShippingMethod ENV["AX_SHIPPING_METHOD"]
          json.Brand ENV["AX_BRAND"]
          json.CustGroup ENV["AX_CUST_GROUP"]
          json.Currency "AUD"
          json.Total order.total_price
          json.Items items
          json.ShippingAddress do
            json.Title customer.try(:title).to_s
            json.FirstName customer.try(:first_name).to_s
            json.LastName customer.try(:last_name).to_s
            json.PhoneNumber customer.try(:phone_number).to_s
            json.AddressOne customer.try(:address_one).to_s
            json.AddressTwo customer.try(:address_two).to_s
            json.City customer.city
            json.State customer.state
            json.PostCode customer.postal_code
            json.Country ENV["AX_COUNTRY"]
          end
        end
      end
    end
  end

  def items
    all_items = []

    order.line_items.each do |line_item|
      if line_item.product.operator_id == 1
        all_items.push({
          "Item": {
            "ItemId": line_item.variant.item_code,
            "ItemDesc": line_item.product.name,
            "Quantity": line_item.quantity,
            "UnitPrice": line_item.price_with_add_ons.to_s,
            "SupplierProductCode": "#{line_item.variant.supplier_product_code}#{line_item.add_ons.map{|x| x.add_on_code}.join('')}",
            "DepartureDate": line_item.variant.product.disable_departure_date? ? '' : line_item.variant.departure_date.strftime('%Y-%m-%d')
          }
        })
      end
    end

    all_items
  end

end
