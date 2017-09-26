Spree::LineItem.class_eval do
  has_many :passengers, dependent: :destroy

  accepts_nested_attributes_for :passengers

  after_commit :check_passengers, on: :update

  scope :not_miscellaneous_charges,
    -> {
      includes(:variant).
        where(spree_variants: { miscellaneous_charges: false }) 
    }

  def total_price
    if request_installments?
      single_money_with_add_ons.money.to_f * quantity / 5.0
    else
      single_money_with_add_ons.money.to_f * quantity
    end
  end

  def total_price_without_installments
    single_money_with_add_ons.money.to_f * quantity
  end

  def passengers_added?
    quantity == passengers.count
  end

  def set_request_installments!
    update(request_installments: true)
  end

  def add_on_names
    add_ons.pluck(:name).join(', ')
  end

  def add_ons_info
    solution = []
    add_ons.each do |ao|
      solution << { name: ao.name, price: ao.prices.first.amount }
    end
    solution
  end

  def product_options
    options = ""

    unless product.disable_room_type
      options << '<li>' + variant.room_type.titleize + '</li>'
    end

    unless product.disable_maturity
      options << '<li>' + variant.maturity.titleize + '</li>'
    end

    unless product.disable_bed_type
      options << '<li>' + variant.bed_type.titleize + '</li>'
    end

    unless product.disable_departure_city
      options << '<li>Depart From: ' + variant.departure_city.titleize + '</li>'
    end

    unless product.disable_departure_date
      options << '<li> Depart On: ' + variant.departure_date.strftime('%d %b %Y') + '</li>'
    end

    unless product.disable_package_option
      options << '<li>' + variant.package_option.titleize + '</li>'
    end

    unless product.disable_accommodation
      options << '<li>' + variant.accommodation.titleize + '</li>'
    end

    options
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
