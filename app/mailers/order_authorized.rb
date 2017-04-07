require 'open-uri'

class OrderAuthorized < ActionMailer::Base
  default from: "My Discoveries <info@mydiscoveries.herokuapp.com>"

  def notification(order_id)
    @order  = Spree::Order.find(order_id)
    @passengers = @order.passengers
    @customer   = @order.customer

    response = GeneratePdf.call(@order)

    if response[:success]
      @order.update(voucher_sent: true)
      attachments[response[:file_name]] = response[:file]
      @order.products.each do |product|
        if product.itinerary.url.present?
          file_contents = open(product.itinerary.url) {|f| f.read }
          attachments["offer_itinerary_#{product.id}.pdf"] = file_contents
        end
      end

      mail(to: @customer.email, bcc: "mydiscoveries_booking@boundround.com", subject: "Your MyDiscoveries Holiday Voucher")
    end
  end
end
