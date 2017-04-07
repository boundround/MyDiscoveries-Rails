Spree::LineItem.class_eval do
  has_many :passengers, dependent: :destroy

  def set_request_installments!
    update(request_installments: true)
  end

  def total_price
    request_installments ? (price * quantity / 5.0) : (price * quantity)
  end
end
