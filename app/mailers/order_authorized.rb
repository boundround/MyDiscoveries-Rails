class OrderAuthorized < ActionMailer::Base
  def notification(order_id)
    @order  = Order.find(order_id)
    @hero_photo = @order.offer.photos.where(hero: true).last
    @passengers = @order.passengers
    @offer      = @order.offer
    @operator   = @offer.operator
    @customer   = @order.customer

    response = GeneratePdf.call(@order)

    if response[:success]
      @order.update(voucher_sent: true)
      attachments[response[:file_name]] = response[:file]
      mail(to: @customer.email, subject: "The voucher for the trip")
    end
  end
end