require 'net/sftp'
require 'stringio'

class Ax::Upload
  include Service

  initialize_with_parameter_assignment :order

  def call
    process
  end

  private

  def process
    upload(ENV['AX_HOSTNAME'], "/#{ENV['AX_UPLOAD_DIR']}/#{filename}")
    upload(ENV['AX_FTP_HOSTNAME'], "/data/#{ENV['AX_UPLOAD_DIR']}/#{filename}")
  end

  def upload(hostname, path)
    Net::SFTP.start(
      hostname,
      ENV['AX_USERNAME'],
      password: ENV['AX_PASSWORD']
    ) do |sftp|
      io = StringIO.new(build_xml)
      sftp.upload!(io, path)
    end
  end

  def filename
    @filename ||= "#{order.ax_sales_id}.xml"
  end

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
    @offer ||= order.offer
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

  def build_xml
    xml = ::Builder::XmlMarkup.new
    xml.Envelope do
      xml.Order do
        xml.CustAccount    user.ax_cust_account
        xml.SalesId        order.ax_sales_id
        xml.OrderDate      order_date
        xml.OrderTime      order_time
        xml.EmailAddress   customer.email
        xml.ShippingCost   shipping_cost
        xml.ShippingMethod ENV['AX_SHIPPING_METHOD']
        xml.Brand          ENV['AX_BRAND']
        xml.CustGroup      ENV['AX_CUST_GROUP']
        xml.Currency       currency
        xml.Total          order.total_price
        xml.ShippingAddress do
          xml.Title       customer.title
          xml.FirstName   customer.first_name
          xml.LastName    customer.last_name
          xml.PhoneNumber customer.phone_number
          xml.AddressOne  customer.address_one
          if customer.address_two.present?
            xml.AddressTwo customer.address_two
          else
            xml.AddressTwo ''
          end
          if customer.address_three.present?
            xml.AddressThree customer.address_three
          end
          xml.City     customer.city
          xml.State    customer.state
          xml.PostCode customer.postal_code
          xml.Country  ENV['AX_COUNTRY']
        end
        xml.Items do
          order.number_of_adults.times do
            xml.Item do
              xml.ItemId       offer.item_id
              xml.ItemDesc     offer.name
              xml.Quantity     '1'
              xml.UnitPrice    offer.minRateAdult
              xml.OSSPaymSched oss_payment_sched
            end
          end
          order.number_of_children.times do
            xml.Item do
              xml.ItemId       offer.child_item_id
              xml.ItemDesc     offer.name
              xml.Quantity     '1'
              xml.UnitPrice    (offer.minRateChild.presence || offer.minRateAdult)
              xml.OSSPaymSched oss_payment_sched
            end
          end
        end
        xml.Payment do
          xml.Amount            amount
          xml.AuthorisationCode auth_code
          xml.AuthorizationDate auth_date
          xml.AuthorizationTime auth_time
          xml.CardName          card_name
          xml.CardNumber        card_number
          xml.CashPaymentID     transaction_id
          xml.ChargedDate       auth_date
          xml.ChargedTime       auth_time
          xml.CV2Number         cv2number
          xml.ExpiryDate        expiry_date
          xml.GatewayConfigId   ENV['AX_GATEWAY_CONFIG_ID']
          xml.PaymentType       payment_type
          xml.SagePayCardType   sage_pay_card_type
          xml.Status            status
          xml.TokenId           billing_id
          xml.TransactionCode   transaction_code
        end
      end
    end
  end

end
