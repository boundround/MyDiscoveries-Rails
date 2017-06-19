class Payment::PaymentExpress::ProcessAuthRequest
  include Service

  initialize_with_parameter_assignment :credit_card, :order

  def call
    process_request

    if transaction_valid?
      update_order
      send_notification
      if ENV["MYDISCOVERIES_ENV"] == "mydiscoveries_production"
        if Rails.env.production?
          SNA::RequestProcessor.perform_async(order.id) if order.products.where(operator_id: 1).any?
          Ax::Upload.call(order)
        end
      end
    end

    response
  end

  private

  def user_from_db
    @user_from_db ||= User.find_by(email: order.customer.email)
  end

  def new_user
    user = User.new(
      email: order.customer.email,
      guest: true
    )
    user.skip_confirmation_notification!

    # skip password validation
    user.save(validate: false)

    user
  end

  def send_notification
    if order.miscellaneous_charges?
      MiscellaneousCharge.delay.notification(order.id)
    else
      OrderAuthorized.delay.notification(order.id)
    end
  end

  def update_order
    order.update(
      authorized:    true,
      px_response:   px_response_json,
      purchase_date: purchase_date,
      completed_at:  purchase_date,
      user:          order.user || user_from_db || new_user
    )
  end

  def purchase_date
    @purchase_date ||= DateTime.parse(px_response_json['Txn']['Transaction']['RxDate'])
  end

  def response
    { success: transaction_valid?, message: response_message }
  end

  def errors
    @errors ||= []
  end

  def response_message
    if transaction_valid?
      'Payment processed'
    else
      errors.any? ? errors.join(', ') : px_response_json['Txn']['HelpText']
    end
  end

  def transaction_valid?
    errors.empty? && (px_response_json['Txn']['Transaction']['success'].to_i == 1)
  end

  def process_request
    begin
      @px_response ||= RestClient.post(ENV['PX_POST_URL'], build_xml)
    rescue => e
      errors << 'Sorry, there was a gateway problem, try one more time.'
    end
  end

  def px_response
    @px_response
  end

  def px_response_json
    @px_response_json ||= Hash.from_xml(px_response)
  end

  def card_number
    @card_number ||= credit_card.number
  end

  def card_date
    @card_date ||= "#{card_date_month}#{card_date_year}"
  end

  def card_date_month
    @credit_card_month ||= credit_card.date.delete(' ').split('/').first
  end

  def card_date_year
    @credit_card_year ||= credit_card.date.delete(' ').split('/').second.last(2)
  end

  def card_holder_name
    @card_holder_name ||= credit_card.holder_name
  end

  def card_cvv
    @card_cvv ||= credit_card.cvv
  end

  def amount
    @amount ||= sprintf("%.2f", order_price)
  end

  def order_price
    @order_price ||= order.total_price
  end

  # value that uniquely identifies the transaction
  def transaction_id
    @transaction_id ||= "#{order.id}-#{Time.now.to_i}"
  end

  def merchant_reference
    @merchant_reference ||= "Order ID: #{order.id}"
  end

  # 0 - Don't check AVS details with acquirer,
  # but pass them through to Payment Express only.
  # 1 - Attempt AVS check. If the acquirer doesn't support AVS or is unavailable,
  # then transaction will proceed as normal.
  # If AVS is supported it will check the transaction and give the result.
  # 2 - The transactions needs to be checked by AVS,
  # even if isn't available, otherwise the transaction will be blocked.
  # 3 - AVS check will be attempted and any outcome will be recorded,
  # but ignored i.e. transaction will not be declined if AVS fails or unavailable.
  def address_verification_system
    @address_verification_system ||= 0
  end

  # only AUD for the now
  def currency
    @currency ||= 'AUD'
  end

  # only Auth for the now
  def transaction_type
    @transaction_type ||= 'Auth'
  end

  def build_xml
    xml = ::Builder::XmlMarkup.new
    xml.Txn do
      xml.PostUsername      ENV['PX_USERNAME']
      xml.PostPassword      ENV['PX_PASSWORD']
      xml.TxnType           transaction_type
      xml.InputCurrency     currency
      xml.Amount            amount
      xml.CardNumber        card_number
      xml.DateExpiry        card_date
      xml.CardHolderName    card_holder_name
      xml.Cvc2              card_cvv
      xml.MerchantReference merchant_reference
      xml.TxnId             transaction_id
      xml.AvsAction         address_verification_system
      xml.EnableAddBillCard '1'
    end
  end

end
