Spree::Variant.class_eval do

  enum maturity: { adult: 0, child: 1 } unless instance_methods.include? :maturity
  enum bed_type: { single: 0, twin: 1, triple: 2 } unless instance_methods.include? :bed_type

  default_scope { where(miscellaneous_charges: false) }

  before_validation :strip_fields

  validates_presence_of :room_type, if: Proc.new { |v| !v.product.disable_room_type }
  validates_presence_of :departure_city
  validates_presence_of :departure_date
  validates_presence_of :package_option
  validates_presence_of :accommodation

  validate :uniqueness,
    if: Proc.new { |v| !v.miscellaneous_charges? }

  # overrides default getter
  def description
    super
  end

  # overrides default setter
  def description=(value)
    super(value)
  end

  def select_label
    label =
      "Departure city: #{departure_city.capitalize}, \
       Departure Date: #{departure_date.try(:to_date).try(:to_s)}, \
       Package Option: #{package_option.try(:capitalize)}, \
       Hotel / Accommodation: #{accommodation.try(:capitalize)}"

    if !product.disable_room_type
      label << ", Room Type: #{room_type.try(:capitalize)}"
    end

    if !product.disable_bed_type
      label << ", Bed Type: #{bed_type.try(:capitalize)}"
    end

    if !product.disable_maturity
      label << ", Maturity: #{maturity.try(:capitalize)}"
    end

    label
  end

  def monthly_price
    price / 5.0
  end

  def strip_fields
    departure_city.strip! unless departure_city.nil?
    room_type.strip!      unless room_type.nil?
    package_option.strip! unless package_option.nil?
    accommodation.strip!  unless accommodation.nil?
  end

  private

  def uniqueness
    Variant::UniquenessValidator.call(self)
  end
end
