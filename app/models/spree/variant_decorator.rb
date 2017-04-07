Spree::Variant.class_eval do

  enum maturity: { adult: 0, child: 1 } unless instance_methods.include? :maturity
  enum bed_type: { single: 0, twin: 1 } unless instance_methods.include? :bed_type

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
