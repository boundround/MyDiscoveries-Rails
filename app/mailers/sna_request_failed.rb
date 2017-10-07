class SnaRequestFailed < ActionMailer::Base
  default from: "MyDiscoveries <info@mydiscoveries.com.au>"

  def notification(order_id, result)
    @order  = Spree::Order.find(order_id)
    @result = result
    mail(to: 'info@mydiscoveries.com.au', subject: 'Send SNA request problems')
  end
end
