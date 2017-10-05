class SnaRequestFailed < ActionMailer::Base
  default from: "MyDiscoveries <info@mydiscoveries.com.au>"

  def notification(order_id)
    @order  = Spree::Order.find(order_id)

    mail(to: 'donovan@boundround.com', subject: 'Send SNA request problems')
  end
end
