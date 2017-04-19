Spree::LineItem.class_eval do
  has_many :passengers, dependent: :destroy

  accepts_nested_attributes_for :passengers

  def set_request_installments!
    update(request_installments: true)
  end

  after_commit :check_passengers, on: :update

  def total_price
    request_installments ? (price * quantity / 5.0) : (price * quantity)
  end

  def passengers_added?
    quantity == passengers.count
  end

  private

  def check_passengers
    if quantity != passengers.count && passengers.any?
      passengers.destroy_all
      order.set_cart_add_passengers!
    end
  end
end
