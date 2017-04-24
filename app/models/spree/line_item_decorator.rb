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
    remove_extra_passengers if passengers.count > quantity
    order.set_cart_add_passengers! if passengers.count != quantity
  end

  def remove_extra_passengers
    count_difference = passengers.count - quantity
    passengers.last(count_difference).each(&:destroy)
  end
end
