Spree::Variant.class_eval do

  enum maturity: { adult: 0, child: 1 } unless instance_methods.include? :maturity
  enum bed_type: { single: 0, twin: 1, triple: 2 } unless instance_methods.include? :bed_type

  validates :product,
    uniqueness: {
      scope: [:bed_type, :departure_city, :maturity, :room_type],
      message: 'variant should contain a unique combination of Bed Type, Maturity, Departure City, and Room Type'
    }

  # overrides default getter
  def description
    super
  end

  # overrides default setter
  def description=(value)
    super(value)
  end

  def select_label
    "Departure city: #{departure_city.capitalize}, \
     Maturity: #{maturity.capitalize}, \
     Bed Type: #{bed_type.capitalize}"
  end

  def monthly_price
    price / 5.0
  end
end
