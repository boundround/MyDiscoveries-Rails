require 'httparty'

class SNA::Send
  include Service

  initialize_with_parameter_assignment :order

  def call
    process
  end

  def response
    @response ||= Response.new(nil, nil, [], nil)
  end

  private

  def px_response
    @px_response ||= order.px_response
  end

  def transaction
    @transaction ||= px_response['Txn']['Transaction']
  end

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

  def amount
    @amount ||= transaction['Amount']
  end

  def currency
    @currency ||= transaction['CurrencyName']
  end

  def currency
    @currency ||= transaction['CurrencyName']
  end

  def auth_code
    @auth_code ||= transaction['AuthCode']
  end

  def auth_date
    @auth_date ||= transaction['AuthCode']
  end

  def rx_time
    @rx_time ||= Time.parse(transaction['RxDate'])
  end

  def auth_date
    @auth_date ||= rx_time.strftime('%Y-%m-%d')
  end

  def auth_time
    @auth_time ||= rx_time.strftime('%H:%M:%S')
  end

  def card_name
    @card_name ||= transaction['CardHolderName']
  end

  def card_number
    @card_number ||= transaction['CardNumber']
  end

  def expiry_date
    @expiry_date ||= Date.strptime(transaction['DateExpiry'], '%m%y').strftime('%Y-%m-%d')
  end

  def status
    @status ||= (transaction['success'] == '1') ? 'Accepted' : ''
  end

  def billing_id
    @billing_id ||= transaction['DpsBillingId']
  end

  def transaction_code
    @transaction_code ||= transaction['DpsTxnRef']
  end

  def sage_pay_card_type
    @sage_pay_card_type ||= transaction['CardName']
  end

  def transaction_id
    @transaction_id ||= transaction['TransactionId']
  end

  def cv2number
    '***'
  end

  def payment_type
    @payment_type ||= sage_pay_card_type.first
  end

  def oss_payment_sched
    order.request_installments? ? '5' : ''
  end

  def shipping_cost
    '0'
  end

  def process
    # begin
    #   response.http_response = HTTParty.post(
    #     ENV['SNA_WEBHOOK_URL'],
    #     basic_auth: credentials,
    #     headers: { 'Accept' => 'application/json' },
    #     body: order_body
    #   )
    # rescue HTTParty::Error, StandardError => e
    #   response.errors << e.to_s
    # end
    order_body
  end

  def credentials
    { username: ENV['SNA_USERNAME'], password: ENV['SNA_PASSWORD'] }
  end

  def order_body
    envelope = {
      "envelope": {
        "order": {
          "CustAccount": user.ax_cust_account,
          "SalesId": order.ax_sales_id,
          "OrderDate": order_date,
          "OrderTime": order_time,
          "EmailAddress": customer.email,
          "ShippingCost": shipping_cost,
          "ShippingMethod": ENV["AX_SHIPPING_METHOD"],
          "Brand": ENV["AX_BRAND"],
          "CustGroup": ENV["AX_CUST_GROUP"],
          "Currency": currency,
          "Total": order.total_price,
          "ShippingAddress": {
            "Title": customer.title,
            "FirstName": customer.first_name,
            "LastName": customer.last_name,
            "PhoneNumber": customer.phone_number,
            "AddressOne": customer.address_one,
            "AddressTwo": (customer.address_two.presence || ''),
            "City": customer.city,
            "State": customer.state,
            "PostCode": customer.postal_code,
            "Country": ENV["AX_COUNTRY"],
            "Items": items
          }
        }
      }
    }
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
          "OSSPaymSched": oss_payment_sched
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
          "OSSPaymSched": oss_payment_sched
        }
      })
    end
    all_items
  end

end
