require 'open-uri'

class OrderAuthorized < ActionMailer::Base
  default from: "My Discoveries <info@mydiscoveries.herokuapp.com>"

  def notification(order_id)
    @order  = Spree::Order.find(order_id)
    @hero_photo = @order.product.photos.where(hero: true).last
    @passengers = @order.passengers
    @offer      = @order.product
    @operator   = @offer.operator
    @customer   = @order.customer

    response = GeneratePdf.call(@order)

    if response[:success]
      @order.update(voucher_sent: true)
      attachments[response[:file_name]] = response[:file]
      if @offer.itinerary.url.present?
        file_contents = open(@offer.itinerary.url) {|f| f.read }
        attachments["offer_itinerary.pdf"] = file_contents
      end

      mail(to: @customer.email, bcc: "mydiscoveries_booking@boundround.com", subject: "Your MyDiscoveries Holiday Voucher")
    end
  end
end
