require 'open-uri'

class OrderAuthorized < ActionMailer::Base
  default from: "My Discoveries <info@mydiscoveries.com.au>"

  def notification(order_id)
    @order = Spree::Order.find(order_id)
    generated_pdf = GeneratePdf.call(@order)
    return unless generated_pdf[:success]

    @order.update(voucher_sent: true)
    send_email(@order, generated_pdf)
  end

  private

  def send_email(order, generated_pdf)
    add_attachments(order, generated_pdf)

    mail(
      to: to_email(order),
      bcc: "mydiscoveries_booking@boundround.com",
      subject: "Your MyDiscoveries Holiday Voucher"
    )
  end

  def add_attachments(order, generated_pdf)
    attachments[generated_pdf[:file_name]] = generated_pdf[:file]

    products_with_itinerary(order).each do |product|
      file_contents = open(product.itinerary.url) { |file| file.read }
      attachments["offer_itinerary_#{product.id}.pdf"] = file_contents
    end
  end

  def products_with_itinerary(order)
    order.products.select { |product| product.itinerary.url.present? }
  end

  def to_email(order)
    order.customer.email.presence ||
     (order.products.where(operator_id: 1).any? && "noemail@snatours.com") ||
    "bookings@mydiscoveries.com.au"
  end
end
