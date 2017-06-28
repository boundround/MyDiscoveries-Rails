class MiscellaneousCharge < ActionMailer::Base
  default from: "My Discoveries <info@mydiscoveries.herokuapp.com>"

  def notification(order_id)
    @order      = Spree::Order.find(order_id)
    @customer   = @order.customer

    mail(to: @customer.email, subject: "Miscellaneous Charge")
  end
end
