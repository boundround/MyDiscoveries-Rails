require 'httparty'

class SNA::Send
  include Service

  initialize_with_parameter_assignment :order

  def call
    process
  end

  private

  def customer
    @customer ||= order.customer
  end

  def offer
    @offer ||= order.product
  end

  def user
    @user ||= order.user
  end

  def order_date
    @order_date ||= order.created_at.strftime('%Y-%m-%d')
  end

  def order_time
    @order_time ||= order.created_at.strftime('%H:%M:%S')
  end

  def oss_payment_sched
    order.request_installments? ? '5' : ''
  end

  def shipping_cost
    '0'
  end

  def process
    # response = HTTParty.post(
    #   ENV['SNA_WEBHOOK_URL'],
    #   basic_auth: credentials,
    #   headers: { 'Accept' => 'application/json' },
    #   body: order_body)
    puts order_body
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
          json.EmailAddress customer.email.presence || 'info@mydiscoveries.com'
          json.ShippingCost shipping_cost
          json.ShippingMethod ENV["AX_SHIPPING METHOD"]
          json.Brand ENV["AX_BRAND"]
          json.CustGroup ENV["AX_CUST_GROUP"]
          json.Currency "AUD"
          json.Total order.total_price
          json.ShippingAddress do
            json.Title customer.title.presence || ''
            json.FirstName customer.first_name.presence || ''
            json.LastName customer.last_name.presence || ''
            json.PhoneNumber customer.phone_number
            json.AddressOne customer.address_one
            json.AddressTwo (customer.address_two.presence || '')
            json.City customer.city
            json.State customer.state
            json.PostCode customer.postal_code
            json.Country ENV["AX_COUNTRY"]
            json.Items items
          end
        end
      end
    end
  end

  def items
    all_items = []

    order.number_of_adults.times do
      all_items.push({
        "Item": {
          "ItemId": offer.item_id,
          "ItemDesc": offer.name,
          "Quantity": 1,
          "UnitPrice": offer.minRateAdult,
          "SupplierProductCode": offer.supplier_product_code.presence || ""
        }
      })
    end

    order.number_of_children.times do
      all_items.push({
        "Item": {
          "ItemId": offer.child_item_id,
          "ItemDesc": offer.name,
          "Quantity": 1,
          "UnitPrice": (offer.minRateChild.presence || offer.minRateAdult),
          "SupplierProductCode": offer.supplier_product_code.presence || ""
        }
      })
    end
    all_items
  end

end
