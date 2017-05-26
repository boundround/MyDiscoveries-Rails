Spree::Variant.class_eval do

  enum maturity: { adult: 0, child: 1 } unless instance_methods.include? :maturity
  enum bed_type: { single: 0, twin: 1, triple: 2 } unless instance_methods.include? :bed_type

  before_validation :strip_fields

  validates :product,
    uniqueness: {
      scope: [:bed_type, :departure_city, :maturity, :room_type],
      message: 'variant should contain a unique combination of Bed Type, Maturity, Departure City and Room Type'
    }, if: :product_room_type_present?

  validates :product,
    uniqueness: {
      scope: [:bed_type, :departure_city, :maturity],
      message: 'variant should contain a unique combination of Bed Type, Maturity and Departure City'
    }, unless: :product_room_type_present?

  # overrides default getter
  def description
    super
  end

  # overrides default setter
  def description=(value)
    super(value)
  end

  def select_label
    if room_type.present?
      select_label_without_room_type + ", Room Type: #{room_type.capitalize}"
    else
      select_label_without_room_type
    end
  end

  def select_label_without_room_type
    "Departure city: #{departure_city.capitalize}, \
     Maturity: #{maturity.capitalize}, \
     Bed Type: #{bed_type.capitalize}"
  end

  def monthly_price
    price / 5.0
  end

  def product_room_type_present?
    product.room_type_present?
  end

  def strip_fields
    departure_city.strip! unless departure_city.nil?
    room_type.strip!      unless room_type.nil?
  end
end
