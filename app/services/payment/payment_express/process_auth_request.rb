class Payment::PaymentExpress::ProcessAuthRequest
  include Service

  initialize_with_parameter_assignment :payment, :order

  def call
    process_request
    update_order if transaction_valid?
    response
  end

  private

  def update_order
    order.update(status: :authorized, px_response: px_response_json)
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
      errors << "Sorry, there was a gateway problems, try one more time"
    end
  end

  def px_response
    @px_response
  end

  def px_response_json
    @px_response_json ||= Hash.from_xml(px_response)
  end

  def card_number
    @card_number ||= payment.credit_card_number
  end

  def card_date
    @card_date ||= payment.credit_card_date.split('/').join('')
  end

  def card_holder_name
    @card_holder_name ||= payment.credit_card_holder_name
  end

  def card_cvv
    @card_cvv ||= payment.credit_card_cvv
  end

  def amount
    @amount ||= sprintf("%.2f", order_price)
  end

  def order_price
    @order_price ||= order.request_installments? ? order.monthly_price : order.total_price
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
    end
  end

end
